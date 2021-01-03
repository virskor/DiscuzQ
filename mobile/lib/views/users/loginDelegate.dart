import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:discuzq/api/sms.dart';
import 'package:discuzq/widgets/sms/sendSMSField.dart';
import 'package:discuzq/widgets/common/discuzFormContainer.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/registerDelegate.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/users/privacyBar.dart';
import 'package:discuzq/providers/forumProvider.dart';

class LoginDelegate extends StatefulWidget {
  final Function onRequested;

  const LoginDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _LoginDelegateState createState() => _LoginDelegateState();
}

class _LoginDelegateState extends State<LoginDelegate> {
  /// usernameTextfiledController
  final TextEditingController _usernameTextfiledController =
      TextEditingController();

  /// passwordTextfiledController
  final TextEditingController _passwordTextfiledController =
      TextEditingController();

  /// dio
  final CancelToken _cancelToken = CancelToken();

  /// States
  /// 使用短信验证码登录
  bool _enableSMSlogin = false;

  /// 验证码数据
  String _code = "";

  /// 登录按钮标题
  String get _loginCaption => _enableSMSlogin ? "验证码登录" : "用户名登录";

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _usernameTextfiledController.dispose();
    _passwordTextfiledController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: DiscuzAppBar(
          title: '登录',
          brightness: Brightness.light,
          actions: <Widget>[
            // IconButton(
            //   tooltip: '无法登陆',
            //   icon: const DiscuzIcon(CupertinoIcons.question_circle_fill,
            //       color: Colors.white),
            //   onPressed: () => null,
            // )
          ],
        ),
        body: _loginForm,
      );

  /// 生成用于登录的表单
  Widget get _loginForm => Builder(
        builder: (BuildContext context) {
          return Consumer<ForumProvider>(builder:
              (BuildContext context, ForumProvider forum, Widget child) {
            return DiscuzFormContainer(
                child: ListView(
              padding: const EdgeInsets.only(top: 60),
              children: <Widget>[
                ///
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DiscuzText(
                      _loginCaption,
                      textScaleFactor: 1.8,
                      fontWeight: FontWeight.bold,
                    ),
                    DiscuzText(
                      '您将使用$_loginCaption',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                /// username textfiled
                DiscuzTextfiled(
                  controller: _usernameTextfiledController,
                  placeHolder: _enableSMSlogin ? "请输入手机号" : '请输入用户名',
                  borderWidth: .2,
                  borderColor: const Color(0x3F000000),
                  label: _enableSMSlogin ? "手机号" : "用户名",
                  inputType: _enableSMSlogin
                      ? TextInputType.number
                      : TextInputType.text,
                  onChanged: (String _) {
                    setState(() {});
                  },
                ),

                /// password textfiled
                /// 如果用户使用短信验证码登录，则显示的是验证码发送框
                _enableSMSlogin
                    ? SendSMSField(
                        type: MobileVerifyTypes.login,
                        mobile: _usernameTextfiledController.text,
                        onChanged: (String val) {
                          _code = val;
                        },
                      )
                    : DiscuzTextfiled(
                        controller: _passwordTextfiledController,
                        placeHolder: '请输入密码',
                        label: "密码",
                        borderWidth: .2,
                        borderColor: const Color(0x3F000000),
                        obscureText: true,
                      ),

                const SizedBox(height: 10),

                !forum.isSMSEnabled
                    ? const SizedBox()
                    : Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: DiscuzText(
                            _enableSMSlogin ? "用户名密码登录" : "短信验证码登录",
                            primary: true,
                          ),
                          onPressed: () {
                            if (_usernameTextfiledController.text.isNotEmpty) {
                              _usernameTextfiledController.text = "";
                            }
                            setState(() {
                              _enableSMSlogin = !_enableSMSlogin;
                            });
                          },
                        ),
                      ),

                const SizedBox(height: 10),

                /// login button
                DiscuzButton(
                  label: _loginCaption,
                  onPressed: _requestLogin,
                ),

                /// or register an account????
                const SizedBox(height: 10),
                DiscuzButton(
                  label: '没有账号，立即注册',
                  labelColor: Colors.white,
                  color: Colors.blueGrey.withOpacity(.43),
                  onPressed: () => DiscuzRoute.navigate(
                      context: context, widget: const RegisterDelegate()),
                ),

                /// 用户协议
                const SizedBox(height: 20),
                const PrivacyBar()
              ],
            ));
          });
        },
      );

  ///
  /// _requestLogin用户请求登录
  ///
  Future<void> _requestLogin() async {
    final Function closeLoading =
        DiscuzToast.loading(context: context, message: '登陆中');

    /// 短信验证码登录
    if (_enableSMSlogin) {
      try {
        final verifyResult = await SMSApi(context: context).verify(_code,
            mobile: _usernameTextfiledController.text,
            type: MobileVerifyTypes.login,);

        /// 一旦请求结束，就要关闭loading
        closeLoading();

        if (verifyResult == null) {
          DiscuzToast.show(context: context, message: "短信验证码校验失败");
          return;
        }
        await AuthHelper.processLoginByResponseData(verifyResult,
            context: context);

        /// 提示登录成功。关闭对话框，重新初始化信息
        ///
        Navigator.pop(context);

        return;
      } catch (e) {
        closeLoading();
        print(e);
        return;
      }
    }

    /// 使用用户名密码登录
    if (_usernameTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写用户名");
      closeLoading();
      return;
    }

    if (_passwordTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写密码");
      closeLoading();
      return;
    }

    try {
      final data = {
        "data": {
          "attributes": {
            "username": _usernameTextfiledController.text,
            "password": _passwordTextfiledController.text,
          }
        }
      };

      Response resp = await Request(context: context, autoAuthorization: false)
          .postJson(_cancelToken, url: Urls.usersLogin, data: data);

      /// 一旦请求结束，就要关闭loading
      closeLoading();

      if (resp == null) {
        /// 提示登录失败信息
        return;
      }

      await AuthHelper.processLoginByResponseData(resp.data, context: context);

      /// 提示登录成功。关闭对话框，重新初始化信息
      ///
      Navigator.pop(context);
    } catch (e) {
      closeLoading();
      print(e);
      throw e;
    }
  }
}
