import 'package:discuzq/widgets/editor/discuzEditorRequestResult.dart';
import 'package:discuzq/widgets/threads/threadsCacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/editor/discuzEditorHelper.dart';
import 'package:discuzq/widgets/posts/postLikeButton.dart';

const int _tapReplyButton = 1;
const int _tapFavoriteButton = 2;
// const int _tapRewardButton = 3;

///
/// 梯子详情底部工具栏
///
class ThreadExtendBottomBar extends StatefulWidget {
  ///
  /// 关联的主题
  final ThreadModel thread;

  ///
  /// 首贴
  final PostModel firstPost;

  ///
  /// 点击了点赞按钮
  /// onLikeTap(bool isLike){
  /// }
  final Function onLikeTap;

  ///
  /// 帖子缓存器
  ///
  final ThreadsCacher threadsCacher;

  ThreadExtendBottomBar(
      {@required this.thread,
      this.onLikeTap,
      @required this.threadsCacher,
      @required this.firstPost});

  @override
  _ThreadExtendBottomBarState createState() => _ThreadExtendBottomBarState();
}

class _ThreadExtendBottomBarState extends State<ThreadExtendBottomBar> {
  ///
  /// states
  ///

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.firstPost.id == 0) {
      return const SizedBox();
    }
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) {
          final List<_ThreadExtendBottomBarItem> _menus = [
            ///
            /// 回复
            const _ThreadExtendBottomBarItem(
                attributes: SFSymbols.bubble_left_bubble_right,
                caption: '回复',
                uniqueId: _tapReplyButton),

            ///
            /// 点赞
            _ThreadExtendBottomBarItem(
                attributes: PostLikeButton(
                  post: widget.firstPost,
                ),
                caption: '点赞',
                uniqueId: _tapFavoriteButton),

            ///
            /// 打赏
            ///
            // const _ThreadExtendBottomBarItem(
            //     attributes: SFSymbols.money_yen_circle,
            //     caption: '打赏',
            //     uniqueId: _tapRewardButton),
          ];
          return Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                border: Border(top: Global.border),
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: SafeArea(
              top: false,
              bottom: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _menus
                    .map((el) => GestureDetector(
                          onTap: () => _onItemTapped(uniqueId: el.uniqueId),
                          child: Row(
                            children: <Widget>[
                              el.attributes.runtimeType == IconData
                                  ? DiscuzIcon(
                                      el.attributes,
                                      color:
                                          DiscuzApp.themeOf(context).textColor,
                                    )
                                  : el.attributes,
                              const SizedBox(width: 5),
                              DiscuzText(el.caption),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          );
        });
  }

  ///
  /// 用户点击了底部按钮的选项
  void _onItemTapped({@required int uniqueId}) async {
    ///
    /// 点赞按钮事件不用处理
    if (uniqueId == _tapFavoriteButton) {
      return;
    }

    ///
    /// 处理用户点击回复
    if (uniqueId == _tapReplyButton) {
      final DiscuzEditorRequestResult res =
          await DiscuzEditorHelper(context: context)
              .reply(post: widget.firstPost, thread: widget.thread);
      if (res != null) {
        widget.threadsCacher.posts = res.posts;
        widget.threadsCacher.users = res.users;
        DiscuzToast.success(context: context, message: '回复成功');
      }
      return;
    }

    ///
    /// 有的选项暂不支持，比如打赏
    DiscuzToast.failed(context: context, message: '暂不支持');
  }
}

class _ThreadExtendBottomBarItem {
  ///
  /// item标题
  ///
  final String caption;

  ///
  /// item图标
  /// 类型限制 IconData || Widget
  ///
  final dynamic attributes;

  ///
  ///  item uniqueId
  ///  用户点击实践中，用于判断选中按钮的依据
  ///  请不要重复
  final int uniqueId;

  ///
  /// reverse selected state
  /// bool
  final bool selected;

  const _ThreadExtendBottomBarItem(
      {this.caption = '',
      @required this.attributes,
      @required this.uniqueId,
      this.selected = false});
}
