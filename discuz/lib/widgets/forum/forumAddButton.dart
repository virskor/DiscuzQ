import 'package:discuzq/router/route.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/views/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:popup_menu/popup_menu.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';

class ForumAddButton extends StatefulWidget {
  ///
  /// 图标颜色永远渲染白色
  final bool awalysDark;

  const ForumAddButton({Key key, this.awalysDark = false}) : super(key: key);
  @override
  _ForumAddButtonState createState() => _ForumAddButtonState();
}

class _ForumAddButtonState extends State<ForumAddButton> {
  final GlobalKey btnKey = GlobalKey();

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
    return IconButton(
      key: btnKey,
      icon: DiscuzIcon(
        SFSymbols.plus,
        color: widget.awalysDark
            ? Colors.white
            : DiscuzApp.themeOf(context).textColor,
      ),
      onPressed: _showPop,
    );
  }

  void _showPop() {
    PopupMenu menu = PopupMenu(
        context: context,
        items: [
          MenuItem(
              title: '发主题',
              image: Icon(
                SFSymbols.pencil_ellipsis_rectangle,
                color: Colors.white,
              )),
          MenuItem(
              title: '发长文',
              image: Icon(
                SFSymbols.pencil_outline,
                color: Colors.white,
              )),
          // MenuItem(
          //     title: '扫一扫',
          //     image: Icon(
          //       SFSymbols.qrcode_viewfinder,
          //       color: Colors.white,
          //     )),
        ],
        onClickMenu: (MenuItemProvider item) {
          /// todo, 要根据item.menuTitle 来展示不同的编辑器
          /// 长文编辑器和一般的编辑器是不一样的
          return DiscuzRoute.open(context: context, widget: const Editor());
        },
        stateChanged: (bool isShow) => null,
        onDismiss: () {});

    menu.show(widgetKey: btnKey);
  }
}
