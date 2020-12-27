import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzFormContainer.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/users/privacyBar.dart';
import 'package:discuzq/providers/forumProvider.dart';
import 'package:discuzq/models/captchaModel.dart';
import 'package:discuzq/widgets/captcha/tencentCloudCaptcha.dart';
import 'package:discuzq/models/forumModel.dart';

class RegisterDelegate extends StatefulWidget {
  final Function onRequested;

  const RegisterDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _RegisterDelegateState createState() => _RegisterDelegateState();
}

class _RegisterDelegateState extends State<RegisterDelegate> {
  /// usernameTextfiledController
  final TextEditingController _usernameTextfiledController =
      TextEditingController();

  /// passwordTextfiledController
  final TextEditingController _passwordTextfiledController =
      TextEditingController();

  /// dio
  final CancelToken _cancelToken = CancelToken();

  static const String _register_reason = 'mobile register';

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
          title: '注册',
          brightness: Brightness.light,
        ),
        body: _buildRegisterForm,
      );

  /// 生成用于登录的表单
  Widget get _buildRegisterForm => DiscuzFormContainer(
          child: ListView(
        padding: const EdgeInsets.only(top: 60),
        children: <Widget>[
          ///
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const DiscuzText(
                '注册账号',
                textScaleFactor: 1.8,
                fontWeight: FontWeight.bold,
              ),
              DiscuzText(
                '注册一个${Global.appname}账号',
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
            label: "用户名",
          ),

          /// password textfiled
          DiscuzTextfiled(
            controller: _passwordTextfiledController,
            placeHolder: '请输入密码',
            borderWidth: .2,
            borderColor: const Color(0x3F000000),
            obscureText: true,
            label: "密码",
          ),

          const SizedBox(height: 20),

          /// login button
          DiscuzButton(
            label: '注册',
            onPressed: _requestRegister,
          ),

          /// or register an account????
          const SizedBox(height: 10),
          DiscuzButton(
            label: '已经有账号，返回登录',
            labelColor: Colors.white,
            color: Colors.blueGrey.withOpacity(.43),
            onPressed: () => Navigator.pop(context),
          ),

          /// 用户协议
          const SizedBox(height: 20),
          const PrivacyBar()
        ],
      ));

  ///
  /// 请求注册
  ///
  Future<void> _requestRegister() async {
    if (_usernameTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写用户名");
      return;
    }

    if (_passwordTextfiledController.text == "") {
      DiscuzToast.failed(context: context, message: "请填写密码");
      return;
    }

    ///
    /// 启用腾讯云验证码
    /// 初始化时 null
    /// 注意，回复的时候，不需要传入验证码
    CaptchaModel captchaCallbackData;
    try {
      final ForumModel forum = context.read<ForumProvider>().forum;

      /// 回复的时候不需要验证码
      ///
      ///
      /// 仅支持 开启腾讯云验证码的用户调用
      ///
      if (context.read<ForumProvider>().isCaptchaEnabled) {
        captchaCallbackData = await TencentCloudCaptcha.show(
            context: context,

            ///
            /// 传入appID 进行替换，否则无法正常完成验证
            appID: forum.attributes.qcloud.qCloudCaptchaAppID);
        if (captchaCallbackData == null) {
          DiscuzToast.failed(context: context, message: '验证失败');
          return;
        }
      }
    } catch (e) {
      throw e;
    }

    final dynamic data = {
      "data": {
        "attributes": {
          "username": _usernameTextfiledController.text,
          "password": _passwordTextfiledController.text,
          "register_reason": _register_reason,
          "captcha_rand_str":
              captchaCallbackData == null ? "" : captchaCallbackData.randSTR,
          "captcha_ticket":
              captchaCallbackData == null ? "" : captchaCallbackData.ticket,
        }
      }
    };

    final Function closeLoading =
        DiscuzToast.loading(context: context, message: '登陆中');

    try {
      Response resp = await Request(context: context, autoAuthorization: false)
          .postJson(_cancelToken, url: Urls.usersRegister, data: data);

      closeLoading();

      if (resp == null) {
        /// 提示注册失败信息
        return;
      }

      /// 注册成功
      ///
      /// await AuthHelper.processLoginByResponseData(resp.data, state: state);

      DiscuzToast.toast(context: context, message: '注册成功，请登陆');
      Navigator.pop(context);
    } catch (e) {
      closeLoading();
      throw e;
    }
  }
}
