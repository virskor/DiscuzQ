import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzFormContainer.dart';
import 'package:dio/dio.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/users/privacyBar.dart';

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
    _usernameTextfiledController.dispose();
    _passwordTextfiledController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '注册',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildRegisterForm(state),
          ));

  /// 生成用于登录的表单
  Widget _buildRegisterForm(AppState state) => DiscuzFormContainer(
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
            label: '注册',
            onPressed: () => _requestRegister(state),
          ),

          /// or register an account????
          const SizedBox(height: 20),
          DiscuzButton(
            label: '已经有账号，返回登录',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
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
  Future<void> _requestRegister(AppState state) async {
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
          "register_reason": _register_reason,
        }
      }
    };

    Response resp = await Request(context: context, autoAuthorization: false)
        .postJson(url: Urls.usersRegister, data: data);

    closeLoading();

    if (resp == null) {
      /// 提示注册失败信息
      return;
    }

    /// 注册成功
    ///
    /// await AuthHelper.processLoginByResponseData(resp.data, state: state);

    DiscuzToast.success(context: context, message: '注册成功，请登陆');

    Navigator.pop(context);
  }
}
