import 'package:dio/dio.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/device.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:like_button/like_button.dart';

import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/request/urls.dart';

const int _tapReplayButton = 1;
const int _tapFavoriteButton = 2;
const int _tapRewardButton = 3;

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

  ThreadExtendBottomBar(
      {@required this.thread, this.onLikeTap, @required this.firstPost});

  @override
  _ThreadExtendBottomBarState createState() => _ThreadExtendBottomBarState();
}

class _ThreadExtendBottomBarState extends State<ThreadExtendBottomBar> {
  ///
  /// states
  ///
  /// 我刚才是否点击了赞的按钮
  /// 注意： 初始化时不要赋值，如果不为null,所有的按钮状态都会被这个参数决定
  /// 用户点击了点赞按钮，呈现的将是由这个状态决定的按钮渲染结果
  bool _tappedLike;

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
                attributes: SFSymbols.bubble_middle_bottom,
                caption: '回复',
                uniqueId: _tapReplayButton),

            ///
            /// 点赞
            _ThreadExtendBottomBarItem(
                attributes: LikeButton(
                  isLiked: _iLikedIt(state: state),
                  onTap: _onLikeButtonTapped,
                ),
                caption: '点赞',
                uniqueId: _tapFavoriteButton),

            ///
            /// 打赏
            ///
            const _ThreadExtendBottomBarItem(
                attributes: SFSymbols.money_yen_circle,
                caption: '打赏',
                uniqueId: _tapRewardButton),
          ];
          return Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            decoration: BoxDecoration(
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
                                  ? DiscuzIcon(el.attributes)
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
  /// 我是否历史点赞过
  ///
  bool _iLikedIt({AppState state}) {
    ///
    /// 没有登录，也就不存在点赞的可能
    if (state.user == null) {
      return false;
    }

    if (widget.firstPost.relationships == null ||
        widget.firstPost.relationships.likedUsers.length == 0) {
      return false;
    }

    final List<dynamic> users = widget.firstPost.relationships.likedUsers
        .where((u) => state.user.id == int.tryParse(u['id']))
        .toList();
    return users == null || users.length == 0 ? false : true;
  }

  ///
  /// 用户点赞
  Future<bool> _onLikeButtonTapped(isLike) async {
    /// 震动
    Device.emitVibration();

    final dynamic data = {
      "data": {
        "type": "posts",
        "attributes": {
          "isLiked": !isLike,
        }
      }
    };

    /// 先假装反馈结果到UI
    setState(() {
      _tappedLike = !isLike;
    });

    Response resp = await Request(context: context).patch(
        url: "${Urls.posts}/${widget.firstPost.id.toString()}", data: data);
    if (resp == null) {
      /// 失败了，撤回点赞结果反馈
      setState(() {
        _tappedLike = isLike;
      });

      return Future.value(isLike);
    }

    if (widget.onLikeTap != null) {
      widget.onLikeTap(!isLike);

      /// 回调点赞状态
    }

    return Future.value(!isLike);
  }

  ///
  /// 用户点击了底部按钮的选项
  void _onItemTapped({@required int uniqueId}) {
    ///
    /// 点赞按钮事件不用处理
    if (uniqueId == _tapFavoriteButton) {
      return;
    }
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
