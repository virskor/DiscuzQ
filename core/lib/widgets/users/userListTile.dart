import 'package:flutter/material.dart';

import 'package:core/models/userModel.dart';
import 'package:core/router/route.dart';
import 'package:core/views/users/userHomeDelegate.dart';
import 'package:core/widgets/common/discuzAvatar.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/utils/global.dart';

///
/// 用于显示用户搜索结果的用户Tile组件
/// 可以查看用户头像，点击查看用户主页详情
class UserListTile extends StatelessWidget {
  ///
  /// 用于显示的用户
  final UserModel user;

  UserListTile({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: const Border(bottom: Global.border),
          color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        children: <Widget>[
          DiscuzListTile(
            leading: DiscuzAvatar(
              url: user.attributes.avatarUrl,
              size: 40,
            ),
            title: DiscuzText(
              user.attributes.username,
              fontWeight: FontWeight.bold,
            ),
            onTap: () => DiscuzRoute.navigate(
                context: context,
                widget: UserHomeDelegate(
                  user: user,
                )),
          ),
        ],
      ),
    );
  }
}
