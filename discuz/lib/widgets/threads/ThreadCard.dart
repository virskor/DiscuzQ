import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/threads/threadHeaderCard.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/threads/threadPostSnapshot.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/threads/theadDetailDelegate.dart';

///
/// 主题卡片
/// 用于展示一个主题的快照，但不是详情
class ThreadCard extends StatefulWidget {
  ///
  /// thread
  /// 主题
  ///
  final ThreadModel thread;

  ///------------------------------
  /// threadsCacher 是用于缓存当前页面的主题数据的对象
  final ThreadsCacher threadsCacher;

  ThreadCard({this.thread, @required this.threadsCacher});
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
    _author = widget.threadsCacher.users
            .where((UserModel it) =>
                it.id ==
                int.tryParse(widget.thread.relationships.user['data']['id']))
            .toList()[0] ??
        UserModel();

    /// 查找firstPost
    _firstPost = widget.threadsCacher.posts
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
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                GestureDetector(
                  onTap: () => DiscuzRoute.open(
                      context: context,
                      shouldLogin: true,
                      widget: const ThreadDetailDelegate()),
                  child: DiscuzText(
                    _firstPost.attributes.content,
                  ),
                )
              ],
            ),
          ),
          ThreadPostSnapshot(
            replyCounts: widget.thread.attributes.postCount,
            lastThreePosts: widget.thread.relationships.lastThreePosts,
            firstPost: _firstPost,
            threadsCacher: widget.threadsCacher,
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
