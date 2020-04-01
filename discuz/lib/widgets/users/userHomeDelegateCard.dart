import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/users/userFollow.dart';

///
/// 用户主页顶部卡片
///
class UserHomeDelegateCard extends StatefulWidget {
  ///
  /// 指定要显示的用户
  final UserModel user;

  ///
  /// 高度
  final double height;

  UserHomeDelegateCard({Key key, @required this.user, this.height})
      : super(key: key);

  @override
  _UserHomeDelegateCardState createState() => _UserHomeDelegateCardState();
}

class _UserHomeDelegateCardState extends State<UserHomeDelegateCard> {
  ///
  /// state
  /// 关注组件传入的新的用户模型
  UserModel _user = UserModel();

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    /// 这个操作要在 super.setState 前，否则不会作用到UI
    _user = widget.user;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            height: widget.height,
            width: MediaQuery.of(context).size.width,

            ///
            /// 要防止overflow哦
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DiscuzListTile(
                    leading: Hero(
                      tag: 'heroAvatar',
                      child: DiscuzAvatar(
                        url: widget.user.attributes.avatarUrl,
                        size: 45,
                      ),
                    ),
                    title: DiscuzText(
                      widget.user.attributes.username,
                      fontSize: DiscuzApp.themeOf(context).mediumTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: UserFollow(
                      user: widget.user,
                      onUserChanged: (UserModel user) => setState(() {
                        _user = user;
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          DiscuzText(
                            widget.user.attributes.threadCount.toString(),
                            fontWeight: FontWeight.bold,
                          ),
                          DiscuzText(
                            '主题',
                            color: DiscuzApp.themeOf(context).greyTextColor,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          DiscuzText(
                            widget.user.attributes.followCount.toString(),
                            fontWeight: FontWeight.bold,
                          ),
                          DiscuzText(
                            '关注',
                            color: DiscuzApp.themeOf(context).greyTextColor,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          DiscuzText(
                            _user.attributes.fansCount.toString(),
                            fontWeight: FontWeight.bold,
                          ),
                          DiscuzText(
                            '被关注',
                            color: DiscuzApp.themeOf(context).greyTextColor,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
}
