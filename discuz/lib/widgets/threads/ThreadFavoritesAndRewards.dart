import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/users/userLink.dart';

final ThreadsCacher _threadsCacher = ThreadsCacher();

class ThreadFavoritesAndRewards extends StatelessWidget {
  ///
  /// 主题
  final ThreadModel thread;

  ///
  /// firstPost
  final PostModel firstPost;

  const ThreadFavoritesAndRewards({this.thread, this.firstPost});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> likedUsers = firstPost.relationships.likedUsers;
    List<Widget> likedUsersWidgets = [];

    final List<dynamic> rewardedUsers = thread.relationships.rewardedUsers;
    List<Widget> rewardedUsersWidgets = [];

    print(rewardedUsers.toString());

    ///
    /// 如果点赞和打赏都没有，那么久直接返回 sizedbox 好了
    ///
    if (likedUsers.length == 0 && rewardedUsers.length == 0) {
      return SizedBox();
    }

    /// 生成打赏列表
    rewardedUsers.forEach((dynamic e) {
      try {
        final int uid = int.tryParse(e['id']);
        final List<UserModel> findUsers =
            _threadsCacher.users.where((u) => u.id == uid).toList();

        if (findUsers != null && findUsers.length > 0) {
          rewardedUsersWidgets.addAll([
            UserLink(
              user: findUsers[0],
            ),
          ]);
        }
      } catch (e) {}
    });

    /// 生成点赞用户列表
    likedUsers.forEach((dynamic e) {
      try {
        final int uid = int.tryParse(e['id']);
        final List<UserModel> findUsers =
            _threadsCacher.users.where((u) => u.id == uid).toList();

        if (findUsers != null && findUsers.length > 0) {
          likedUsersWidgets.addAll([
            UserLink(
              user: findUsers[0],
            ),
          ]);
        }
      } catch (e) {}
    });

    /// 增加打赏部件
    if(rewardedUsersWidgets.length >0){
      /// 增加心形状 图标
      rewardedUsersWidgets.insert(
          0,
          Padding(
            padding: EdgeInsets.only(top: 1, right: 10, left: 0),
            child: DiscuzIcon(
              SFSymbols.money_yen_circle_fill,
              color: Colors.redAccent,
              size: 20,
            ),
          ));
    }


    /// 增加点赞其他部件
    if (likedUsersWidgets.length > 0) {
      ///
      /// 增加 点赞人数
      if (firstPost.attributes.likeCount > 5) {
        likedUsersWidgets
            .add(DiscuzText('等${firstPost.attributes.likeCount}人觉得很赞'));
      }

      /// 增加心形状 图标
      likedUsersWidgets.insert(
          0,
          Padding(
            padding: EdgeInsets.only(top: 1, right: 10, left: 0),
            child: DiscuzIcon(
              SFSymbols.suit_heart_fill,
              size: 20,
            ),
          ));
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ///
          /// 点赞的用户
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ...likedUsersWidgets,
            ],
          ),

          /// 打赏的用户
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ...rewardedUsersWidgets,
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
