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

  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              elevation: 10,
              centerTitle: true,
              title: '注册',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildLoginForm(),
          ));

  /// app logo
  Widget _logo = const Center(
    child: const DiscuzAppLogo(
      width: 150,
    ),
  );

  /// 生成用于登录的表单
  Widget _buildLoginForm() => DiscuzFormContainer(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// ... if you want a logo to be rendered
          // _logo,

          ///
          const DiscuzText(
            '要注册的用户名',
            textScaleFactor: 1.5,
            fontWeight: FontWeight.bold,
          ),
          const DiscuzText(
            '注册一个${Global.appname}账号来分享',
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
            label: '注册',
            onPressed: () => null,
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
}
