import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/users/userHomeDelegateCard.dart';

class UserHomeDelegate extends StatefulWidget {
  final dynamic user;

  UserHomeDelegate({Key key, @required this.user}) : super(key: key);

  @override
  _UserHomeDelegateState createState() => _UserHomeDelegateState();
}

class _UserHomeDelegateState extends State<UserHomeDelegate> {
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
    //print(widget.user.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              centerTitle: true,
              title: "${widget.user['attributes']['username']}的个人主页",
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: ListView(
              children: <Widget>[
                ///
                /// 用户信息卡片
                /// 用于显示粉丝数量
                /// 关注或取消
                UserHomeDelegateCard(
                  user: widget.user,
                ),
              ],
            ),
          ));
}
