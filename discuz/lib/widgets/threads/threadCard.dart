import 'package:discuzq/utils/StringHelper.dart';
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
import 'package:discuzq/views/threads/threadDetailDelegate.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';
import 'package:discuzq/widgets/threads/parts/threadGalleriesSnapshot.dart';
import 'package:discuzq/widgets/threads/parts/threadVideoSnapshot.dart';
import 'package:discuzq/widgets/threads/parts/threadCardQuickActions.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzExpansionTile.dart';

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

  ///
  /// ------
  /// 当卡片被删除，注意，因为该组件存在threadsCacher，所以删除threadsCacher来影响UIbuild的过程在该组件内
  /// 其次，注意，该回调仅用于其他处理，不用在处理删除显示当前主题
  final Function onDelete;

  ///
  /// ----
  /// initiallyExpanded
  /// 默认是否展开(为置顶的主题默认展开)
  final bool initiallyExpanded;

  ThreadCard(
      {this.thread,
      @required this.threadsCacher,
      this.onDelete,
      this.initiallyExpanded = false});
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

  ///
  /// Build 卡片的的过程中需要注意的是，如果主题顶置，则需要支持收起
  @override
  Widget build(BuildContext context) => RepaintBoundary(
      child: widget.thread.attributes.isSticky
          ? _buildExpansion()
          : _buildThreadCard(context));

  ///
  /// 生成简单的标题，取固定值
  ///
  String get _flatTitle => widget.thread.attributes.title != ''
      ? widget.thread.attributes.title
      : "${_firstPost.attributes.content.substring(0, 15)}...";

  ///
  /// 可收起的主题
  ///
  Widget _buildExpansion() => DiscuzExpansionTile(
      initiallyExpanded: widget.initiallyExpanded,
      title: DiscuzText(
        _flatTitle,
        fontWeight: FontWeight.bold,
      ),
      leading: const DiscuzIcon(
        0xe70f,
        size: 20,
        withOpacity: true,
      ),
      backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
      children: <Widget>[_buildThreadCard(context)]);

  ///
  /// 构建帖子卡片
  ///
  Widget _buildThreadCard(BuildContext context) => Container(
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
                  widget.thread.attributes.title != ''
                      ? const SizedBox()
                      : GestureDetector(
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

            ///
            /// 梯子快捷操作工具栏
            ThreadCardQuickActions(
              firstPost: _firstPost,
              thread: widget.thread,
            ),

            /// 楼层评论
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
      );

  /// 显示主题的标题
  /// 并不是所有主题都有标题，所以要做判断
  List<Widget> _buildContentTitle() =>
      StringHelper.isEmpty(string: widget.thread.attributes.title)
          ? <Widget>[]
          : <Widget>[
              GestureDetector(
                onTap: () => DiscuzRoute.open(
                    context: context,
                    shouldLogin: true,
                    widget: ThreadDetailDelegate(
                      author: _author,
                      thread: widget.thread,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: DiscuzText(
                        widget.thread.attributes.title.length <= 15
                            ? widget.thread.attributes.title
                            : "${widget.thread.attributes.title.substring(0, 15)}...",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DiscuzIcon(SFSymbols.doc_plaintext),
                  ],
                ),
              )
            ];
}
