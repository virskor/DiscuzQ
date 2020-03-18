import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzFormContainer.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/registerDelegate.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/users/privacyBar.dart';

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

  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              title: '登录',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildLoginForm(model),
          ));

  /// app logo
  Widget _logo = const Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: const Center(
        child: const DiscuzAppLogo(
          width: 150,
        ),
      ));

  /// 生成用于登录的表单
  Widget _buildLoginForm(AppModel model) => DiscuzFormContainer(
          child: ListView(
        padding: const EdgeInsets.only(top: 60),
        children: <Widget>[
          /// ... if you want a logo to be rendered
          _logo,

          ///
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const DiscuzText(
                '用户名登录',
                textScaleFactor: 1.8,
                fontWeight: FontWeight.bold,
              ),
              const DiscuzText(
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
            onPressed: () => _requestLogin(model),
          ),

          /// or register an account????
          const SizedBox(height: 20),
          DiscuzButton(
            label: '没有账号，立即注册',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
            onPressed: () => DiscuzRoute.open(
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
  Future<void> _requestLogin(AppModel model) async {
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

    await AuthHelper.processLoginByResponseData(resp.data, model: model);

    /// 提示登录成功。关闭对话框，重新初始化信息
    ///
    Navigator.pop(context);
  }
}
