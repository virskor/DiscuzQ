import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/utils/global.dart';

class LoginDelegate extends StatefulWidget {
  final Function onRequested;

  const LoginDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _LoginDelegateState createState() => _LoginDelegateState();
}

class _LoginDelegateState extends State<LoginDelegate> {
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              elevation: 10,
              centerTitle: true,
              title: '登录${Global.appname}',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildLoginForm(),
          ));
  
  /// 生成用于登录的表单
  Widget _buildLoginForm() => Column(
    children: <Widget>[],
  );
}
