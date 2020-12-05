import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzFormContainer.dart';
import 'package:core/router/route.dart';
import 'package:core/views/users/registerDelegate.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/utils/authHelper.dart';
import 'package:core/widgets/users/privacyBar.dart';

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
  Widget get _loginForm => DiscuzFormContainer(
          child: ListView(
        padding: const EdgeInsets.only(top: 60),
        children: <Widget>[
          ///
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const DiscuzText(
                '用户名登录',
                textScaleFactor: 1.8,
                fontWeight: FontWeight.bold,
              ),
              DiscuzText(
                '现在登录${Global.appname}分享瞬间吧',
              ),
              const SizedBox(height: 20),
            ],
          ),

          /// username textfiled
          DiscuzTextfiled(
            controller: _usernameTextfiledController,
            placeHolder: '请输入用户名',
            borderWidth: .2,
            borderColor: const Color(0x3F000000),
          ),

          /// password textfiled
          DiscuzTextfiled(
            controller: _passwordTextfiledController,
            placeHolder: '请输入密码',
            borderWidth: .2,
            borderColor: const Color(0x3F000000),
            obscureText: true,
          ),

          const SizedBox(height: 20),

          /// login button
          DiscuzButton(
            label: '登录',
            onPressed: _requestLogin,
          ),

          /// or register an account????
          const SizedBox(height: 20),
          DiscuzButton(
            label: '没有账号，立即注册',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
            onPressed: () => DiscuzRoute.navigate(
                context: context, widget: const RegisterDelegate()),
          ),

          /// 用户协议
          const SizedBox(height: 20),
          const PrivacyBar()
        ],
      ));

  ///
  /// _requestLogin用户请求登录
  ///
  Future<void> _requestLogin() async {
    if (_usernameTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写用户名");
      return;
    }

    if (_passwordTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写密码");
      return;
    }

    final Function closeLoading =
        DiscuzToast.loading(context: context, message: '登陆中');

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
          .postJson(url: Urls.usersLogin, data: data);

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
