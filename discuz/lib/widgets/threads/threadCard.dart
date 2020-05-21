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
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';

///
/// flat title length to substr
const int _kFlatTitleLength = 15;

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

  ///
  /// 是否需要支付才能查看
  bool get _requiredPaymentToPlay => widget.thread.attributes.paid ||
          double.tryParse(widget.thread.attributes.price) == 0
      ? false
      : true;

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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => RepaintBoundary(
            child: _buildCard(state: state, context: context),
          ));

  ///
  /// 生成内容
  /// 实际上，我们会收起顶置的帖子
  /// 其次，如果用户设置了收起付费的帖子，他们也会被折叠，但用不同的颜色提示
  Widget _buildCard({BuildContext context, AppState state}) {
    if (widget.thread.attributes.isSticky) {
      return _buildExpansion(context);
    }

    return state.appConf['hideContentRequirePayments'] && _requiredPaymentToPlay
        ? _buildExpansion(context)
        : _buildThreadCard(context);
  }

  ///
  /// 生成简单的标题，取固定值
  ///
  String get _flatTitle => widget.thread.attributes.title != ''
      ? widget.thread.attributes.title
      : _firstPost.attributes.content.length <= _kFlatTitleLength
          ? _firstPost.attributes.content
          : "${_firstPost.attributes.content.substring(0, _kFlatTitleLength)}...";

  ///
  /// 可收起的主题
  ///
  Widget _buildExpansion(BuildContext context) {
    final Widget leadingIcon = DiscuzIcon(
      widget.thread.attributes.isSticky
          ? 0xe70f
          : SFSymbols.money_dollar_circle_fill,
      size: widget.thread.attributes.isSticky ? 20 : 25,
      withOpacity: true,
    );

    return DiscuzExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        dense: true,
        title: DiscuzText(
          _flatTitle,
          fontWeight: FontWeight.bold,
        ),
        leading: leadingIcon,
        backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
        children: <Widget>[_buildThreadCard(context)]);
  }

  ///
  /// 构建帖子卡片
  ///
  Widget _buildThreadCard(BuildContext context) => Container(
        padding:
            const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).backgroundColor,
        ),
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
              padding: EdgeInsets.only(top: 10),
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
                          child: HtmlRender(
                            html: _firstPost.attributes.contentHtml,
                          ),
                        ),

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
                        ),
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
            const SizedBox(height: 10),
            const DiscuzDivider(padding: 0,)
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          DiscuzText(
                            widget.thread.attributes.title.length <=
                                    _kFlatTitleLength
                                ? widget.thread.attributes.title
                                : "${widget.thread.attributes.title.substring(0, _kFlatTitleLength)}...",
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const DiscuzIcon(SFSymbols.doc_plaintext),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ];
}
