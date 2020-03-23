import 'package:discuzq/widgets/users/userFollow.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/userModel.dart';

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
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            height: widget.height,

            ///
            /// 要防止overflow哦
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ///
                  /// avatar
                  Center(
                    child: Hero(
                      tag: 'heroAvatar',
                      child: DiscuzAvatar(
                        url: widget.user.avatarUrl,
                      ),
                    ),
                  ),

                  ///
                  /// username
                  const SizedBox(height: 10),
                  DiscuzText(
                    widget.user.username,
                    fontSize: DiscuzApp.themeOf(context).mediumTextSize,
                    fontWeight: FontWeight.bold,
                  ),

                  _buildFollowsTag(state),
                ],
              ),
            ),
          ));

  ///
  /// 生成描述关注情况的概览
  ///
  Widget _buildFollowsTag(AppState state) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: UserFollow(
          user: widget.user,
        ),
      );
}
