import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

const int _tapReplayButton = 1;
const int _tapFavoriteButton = 2;
const int _tapRewardButton = 3;

///
/// 梯子详情底部工具栏
///
class ThreadExtendBottomBar extends StatefulWidget {
  const ThreadExtendBottomBar();

  @override
  _ThreadExtendBottomBarState createState() => _ThreadExtendBottomBarState();
}

class _ThreadExtendBottomBarState extends State<ThreadExtendBottomBar> {
  final List<_ThreadExtendBottomBarItem> _menus = [
    ///
    /// 回复
    const _ThreadExtendBottomBarItem(
        attributes: SFSymbols.bubble_middle_bottom,
        caption: '回复',
        uniqueId: _tapReplayButton),

    ///
    /// 点赞
    const _ThreadExtendBottomBarItem(
        attributes: SFSymbols.heart,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
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
  }

  ///
  /// 用户点击了底部按钮的选项
  void _onItemTapped({@required int uniqueId}) {
    print("tapped ${uniqueId.toString()}");
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
