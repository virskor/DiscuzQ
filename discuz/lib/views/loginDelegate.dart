import 'dart:convert';

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
import 'package:discuzq/views/registerDelegate.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/utils/authorizationHelper.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

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

  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              centerTitle: true,
              title: '登录',
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// ... if you want a logo to be rendered
          // _logo,

          ///
          const DiscuzText(
            '用户名登录',
            textScaleFactor: 1.5,
            fontWeight: FontWeight.bold,
          ),
          const DiscuzText(
            '现在登录${Global.appname}分享瞬间吧',
          ),
          const SizedBox(height: 20),

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
            label: '注册',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
            onPressed: () => DiscuzRoute.open(
                context: context, widget: const RegisterDelegate()),
          ),
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

    ///
    /// 读取accessToken
    ///
    final String accessToken = resp.data['data']['attributes']['access_token'];
    if (StringHelper.isEmpty(string: accessToken) == true) {
      return Future.value(false);
    }

    ///
    /// 读取refreshToken
    ///
    final String refreshToken =
        resp.data['data']['attributes']['refresh_token'];
    if (StringHelper.isEmpty(string: accessToken) == true) {
      return Future.value(false);
    }

    ///
    /// 读取用户信息
    ///
    final List<dynamic> included = resp.data['included'];
    final dynamic user =
        included.where((it) => it['type'] == "users").toList()[0];

    ///
    /// 存储accessToken
    /// 先清除，在保存，否则保存会失败
    /// 调用clear只会清除一个项目，这样会导致用户切换信息错误
    /// 所以要清除token 和用户信息存储，在回调处理中在进行更新用户信息的Process提示
    /// 我不想写update逻辑，就这样简单粗暴无bug多完美？
    ///
    await AuthorizationHelper()
        .clear(key: AuthorizationHelper.authorizationKey);
    await AuthorizationHelper().clear(key: AuthorizationHelper.userKey);
    await AuthorizationHelper().clear(key: AuthorizationHelper.refreshTokenKey);

    /// 保存token
    await AuthorizationHelper()
        .save(data: jsonEncode(user), key: AuthorizationHelper.userKey);
    await AuthorizationHelper()
        .save(data: accessToken, key: AuthorizationHelper.authorizationKey);
    await AuthorizationHelper()
        .save(data: refreshToken, key: AuthorizationHelper.refreshTokenKey);

    /// 更新用户状态
    model.updateUser(user);

    /// 提示登录成功。关闭对话框，重新初始化信息
    ///
    Navigator.pop(context);
  }
}
