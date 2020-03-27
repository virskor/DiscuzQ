import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/popmenu/popmenu.dart';

class ThreadPopMenu extends StatefulWidget {
  ///
  /// 主题
  final ThreadModel thread;

  ThreadPopMenu({@required this.thread});

  @override
  _ThreadPopMenuState createState() => _ThreadPopMenuState();
}

class _ThreadPopMenuState extends State<ThreadPopMenu> {
  final GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
      child: IconButton(
        key: btnKey,
        padding: const EdgeInsets.all(0),
        icon: const DiscuzIcon(SFSymbols.ellipsis),
        onPressed: _showPop,
      ),
    );
  }

  void _showPop() {
    PopupMenu menu = PopupMenu(
        context: context,
        items: [
          MenuItem(
            title: '点赞',
          ),
          MenuItem(
            title: '回复',
          ),
          MenuItem(
            title: widget.thread.attributes.isFavorite ? '取消收藏' : '收藏',
          ),
        ],
        onClickMenu: (MenuItemProvider item) {},
        stateChanged: (bool isShow) => null,
        onDismiss: () {});

    menu.show(widgetKey: btnKey);
  }
}
