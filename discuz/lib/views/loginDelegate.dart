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
              elevation: 10,
              centerTitle: true,
              title: '登录',
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
  Widget _buildLoginForm() => _LoginFormContainer(
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
            onPressed: () => null,
          ),

          /// or register an account????
          const SizedBox(height: 20),
          DiscuzButton(
            label: '注册',
            labelColor: DiscuzApp.themeOf(context).primaryColor,
            color: Colors.transparent,
            onPressed: () => null,
          ),
        ],
      ));
}

class _LoginFormContainer extends StatelessWidget {
  final Widget child;

  _LoginFormContainer({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),

      /// SingleChildScrollView 防止设备不同的情况下，overflow渲染错误
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}
