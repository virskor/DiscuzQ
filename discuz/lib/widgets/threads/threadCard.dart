import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/threads/threadsCacher.dart';
import 'package:discuzq/widgets/threads/parts/threadHeaderCard.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/threads/parts/threadPostSnapshot.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/threads/theadDetailDelegate.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';
import 'package:discuzq/widgets/threads/parts/threadGalleriesSnapshot.dart';
import 'package:discuzq/widgets/threads/parts/threadVideoSnapshot.dart';

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

    /// 查找附件图片
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            color: DiscuzApp.themeOf(context).backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const DiscuzDivider(
                padding: 0,
              ),
              const SizedBox(height: 10),

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
                            widget: ThreadDetailDelegate(
                              author: _author,
                              thread: widget.thread,
                            )),
                        child: Container(
                          child: HtmlRender(
                            html: _firstPost.attributes.contentHtml,
                          ),
                        )),

                    /// 渲染九宫格图片
                    ///
                    ///
                    ThreadGalleriesSnapshot(
                      firstPost: _firstPost,
                      threadsCacher: widget.threadsCacher,
                      thread: widget.thread,
                    ),

                    ///
                    /// 用于渲染小视频
                    ///
                    widget.thread.relationships.threadVideo == null
                        ? const SizedBox()
                        : ThreadVideoSnapshot(
                            threadsCacher: widget.threadsCacher,
                            thread: widget.thread,
                            post: _firstPost,
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
                author: _author,
              ),
            ],
          ),
        ),
      );

  /// 显示主题的标题
  /// 并不是所有主题都有标题，所以要做判断
  List<Widget> _buildContentTitle() => widget.thread.attributes.title == ""
      ? <Widget>[]
      : <Widget>[
          DiscuzText(
            widget.thread.attributes.title,
            fontWeight: FontWeight.bold,
          ),
        ];
}
