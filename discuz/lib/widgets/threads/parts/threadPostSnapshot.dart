import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/users/userLink.dart';
import 'package:discuzq/widgets/threads/parts/ThreadFavoritesAndRewards.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/threads/theadDetailDelegate.dart';
import 'package:discuzq/widgets/posts/postRender.dart';

///
/// 主题下回复的快照
/// 一般ThreadCard中显示的数据只会有3条的
///
/// ThreadPostSnapshot 包含点赞，打赏的信息，还有回复，并增加全部...条回复
///
class ThreadPostSnapshot extends StatelessWidget {
  ///------------------------------
  /// threadsCacher 是用于缓存当前页面的主题数据的对象
  /// 当数据更新的时候，数据会存储到 threadsCacher
  /// threadsCacher 在页面销毁的时候，务必清空 .clear()
  ///
  final ThreadsCacher threadsCacher;

  ///
  /// 主题
  final ThreadModel thread;

  ///
  /// 第一条post
  final PostModel firstPost;

  ///
  /// 最近三条
  final List<dynamic> lastThreePosts;

  ///
  /// 回复总条数
  final int replyCounts;

  ///
  /// author
  /// 作者
  final UserModel author;

  ThreadPostSnapshot(
      {@required this.lastThreePosts,
      @required this.thread,
      @required this.firstPost,
      @required this.threadsCacher,
      @required this.author,
      this.replyCounts = 0});

  @override
  Widget build(BuildContext context) {
    if (lastThreePosts == null || lastThreePosts.length == 0) {
      ///
      /// 没有回复，仅显示点赞和打赏记录
      ///
      return _wrapper(
          context: context,
          child: ThreadFavoritesAndRewards(
            thread: thread,
            firstPost: firstPost,
            threadsCacher: threadsCacher,
          ));
    }

    ///
    /// 构造回复组件
    ///
    final List<Widget> _repliesWidgets = lastThreePosts.map((dynamic p) {
      final PostModel post = threadsCacher.posts
          .where((PostModel e) => e.id == int.tryParse(p['id']))
          .toList()[0];

      ///
      /// 查询回帖用户
      final List<UserModel> userReplayThreads = threadsCacher.users
          .where((UserModel u) =>
              u.id == int.tryParse(post.relationships.user['data']['id']))
          .toList();

      /// 查询二级回复关联用户（查询活肤评论的用户）
      /// post.relationships.replyUser 不一定每个 post中都会存在
      /// todo: 排查故障
      final List<UserModel> userReplyPosts = post.attributes.replyUserID != null
          ? threadsCacher.users
              .where((UserModel u) => u.id == post.attributes.replyUserID)
              .toList()
          : null;
      
      /// 渲染回复的内容和回复的用户
      return Container(
        child: PostRender(
          content: post.attributes.contentHtml,
          prefixsChild: <Widget>[
            /// 用户
            UserLink(
              user: userReplayThreads[0],
            ),

            ///
            /// 有的可能是多次回复 也就是 某某 回复 某某的
            userReplyPosts == null || userReplyPosts.length == 0
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DiscuzText(
                        '回复',
                        color: DiscuzApp.themeOf(context).greyTextColor,
                      ),
                      UserLink(
                        user: userReplyPosts[0],
                      )
                    ],
                  ),
          ],
        ),
      );
    }).toList();

    return _wrapper(
        context: context,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// 点赞和打赏记录
              ThreadFavoritesAndRewards(
                thread: thread,
                firstPost: firstPost,
                threadsCacher: threadsCacher,
              ),

              /// 渲染所有回复记录
              ..._repliesWidgets,

              ///
              /// 回复
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DiscuzLink(
                    padding: const EdgeInsets.only(top: 5),
                    label: '全部${(replyCounts - 1).toString()}条回复',
                    onTap: () => DiscuzRoute.open(
                        context: context,
                        shouldLogin: true,
                        widget: ThreadDetailDelegate(thread: thread, author: author,)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: const DiscuzIcon(SFSymbols.chevron_compact_right,
                        size: 16),
                  ),
                ],
              )
            ]));
  }

  ///
  /// 用于包裹组件
  Widget _wrapper({@required BuildContext context, @required Widget child}) =>
      Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
          top: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
        child: child,
      );
}
