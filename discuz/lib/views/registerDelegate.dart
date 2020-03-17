import 'package:dio/dio.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
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

  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              centerTitle: true,
              title: '注册',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildLoginForm(model),
          ));

  /// app logo
  Widget _logo = const Center(
    child: const DiscuzAppLogo(
      width: 150,
    ),
  );

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
                '注册账号',
                textScaleFactor: 1.8,
                fontWeight: FontWeight.bold,
              ),
              const DiscuzText(
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
            onPressed: () => _requestRegister(model),
          ),

          /// or register an account????
          const SizedBox(height: 20),
          DiscuzButton(
            label: '已经有账号，立即登录',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ));

  ///
  /// 请求注册
  ///
  Future<void> _requestRegister(AppModel model) async {
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
    /// await AuthHelper.processLoginByResponseData(resp.data, model: model);
    
    DiscuzToast.success(context: context, message: '注册成功，请登陆');

    Navigator.pop(context);
  }
}
