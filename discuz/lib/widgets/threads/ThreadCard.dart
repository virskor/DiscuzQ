import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/threads/threadHeaderCard.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/users/userLink.dart';
import 'package:discuzq/widgets/threads/ThreadFavoritesAndRewards.dart';

final ThreadsCacher _threadsCacher = ThreadsCacher();

///
/// 主题卡片
/// 用于展示一个主题的快照，但不是详情
class ThreadCard extends StatefulWidget {
  ///
  /// thread
  /// 主题
  ///
  final ThreadModel thread;

  ThreadCard({this.thread});
  @override
  _ThreadCardState createState() => _ThreadCardState();
}

class _ThreadCardState extends State<ThreadCard> {
  /// 当前帖子的作者
  UserModel _author = UserModel();

  /// firstPost 指定的是主题第一个帖子，其他的是回复
  PostModel _firstPost = PostModel();

  @override
  void initState() {
    super.initState();
    _author = _threadsCacher.users
            .where((UserModel it) =>
                it.id ==
                int.tryParse(widget.thread.relationships.user['data']['id']))
            .toList()[0] ??
        UserModel();

    /// 查找firstPost
    _firstPost = _threadsCacher.posts
            .where((PostModel it) =>
                it.id ==
                int.tryParse(
                    widget.thread.relationships.firstPost['data']['id']))
            .toList()[0] ??
        PostModel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      margin: const EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ///
          /// 主题顶部的用户信息
          ThreadHeaderCard(
            thread: widget.thread,
            author: _author,
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /// 显示主题的title
                ..._buildContentTitle(),

                /// 主题的内容
                DiscuzText(
                  _firstPost.attributes.content,
                )
              ],
            ),
          ),
          _ThreadPostSnapshot(
            replyCounts: widget.thread.attributes.postCount,
            lastThreePosts: widget.thread.relationships.lastThreePosts,
            firstPost: _firstPost,
            thread: widget.thread,
          ),
        ],
      ),
    );
  }

  /// 显示主题的标题
  /// 并不是所有主题都有标题，所以要做判断
  List<Widget> _buildContentTitle() => widget.thread.attributes.title == ""
      ? <Widget>[]
      : <Widget>[
          DiscuzText(
            widget.thread.attributes.title,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          const DiscuzDivider(
            padding: 0,
          ),
          const SizedBox(height: 5),
        ];
}

///
/// 主题下回复的快照
/// 一般ThreadCard中显示的数据只会有3条的
///
/// _ThreadPostSnapshot 包含点赞，打赏的信息，还有回复，并增加全部...条回复
///
class _ThreadPostSnapshot extends StatelessWidget {
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

  _ThreadPostSnapshot(
      {@required this.lastThreePosts,
      @required this.thread,
      @required this.firstPost,
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
          ));
    }

    ///
    /// 构造回复组件
    ///
    final List<Widget> _repliesWidgets = lastThreePosts.map((dynamic p) {
      final PostModel post = _threadsCacher.posts
          .where((PostModel e) => e.id == int.tryParse(p['id']))
          .toList()[0];

      ///
      /// 查询回帖用户
      final List<UserModel> userReplayThreads = _threadsCacher.users
          .where((UserModel u) =>
              u.id == int.tryParse(post.relationships.user['data']['id']))
          .toList();

      /// 查询二级回复关联用户（查询活肤评论的用户）
      /// post.relationships.replyUser 不一定每个 post中都会存在
      /// todo: 排查故障
      final List<UserModel> userReplyPosts = post.attributes.replyUserID != null
          ? _threadsCacher.users
              .where((UserModel u) => u.id == post.attributes.replyUserID)
              .toList()
          : null;

      return Container(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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

            ///
            /// 回复内容
            Flexible(
              child: Container(
                child: DiscuzText(
                  post.attributes.content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
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
          top: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
        child: child,
      );
}
