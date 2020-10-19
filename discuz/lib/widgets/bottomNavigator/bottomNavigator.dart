import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/forum/forumAddButton.dart';

const double _kBottomNavigationElevation = 15;

const double _kPublishButtonSize = 35;

class DiscuzBottomNavigator extends StatefulWidget {
  final ValueChanged<int> onItemSelected;
  final List<NavigatorItem> items;

  DiscuzBottomNavigator({
    @required this.onItemSelected,
    @required this.items,
  }) {
    assert(onItemSelected != null);
  }

  @override
  _DiscuzBottomNavigatorState createState() =>
      _DiscuzBottomNavigatorState(onItemSelected: onItemSelected);
}

class _DiscuzBottomNavigatorState extends State<DiscuzBottomNavigator> {
  final ValueChanged<int> onItemSelected;
  final double height;

  int selectedIndex = 0;

  _DiscuzBottomNavigatorState(
      {@required this.onItemSelected, this.height = 40});
  @override
  Widget build(BuildContext context) {
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) => Material(
              elevation: _kBottomNavigationElevation,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 75),
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: DiscuzApp.themeOf(context).backgroundColor,
                  border: const Border(top: Global.border),
                ),
                child: _buildItems(state: state),
              ),
            ));
  }

  Widget _buildItems({AppState state}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.items.map<Widget>((it) {
        if (it.isPublishButton) {
          return const _PublishButton();
        }

        final int index = widget.items.indexOf(it);

        return IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: DiscuzIcon(
            it.icon,
            size: it.size,
            color: selectedIndex == index
                ? Theme.of(context).primaryColor
                : const Color(0xFF657786),
          ),
          onPressed: () async {
            if (it.shouldLogin == true) {
              bool success = await AuthHelper.requsetShouldLogin(
                  context: context, state: state);
              if (!success) {
                return;
              }
            }

            onItemSelected(index);
            setState(() {
              selectedIndex = index;
            });
          },
        );
      }).toList());
}

class _PublishButton extends StatelessWidget {
  const _PublishButton();

  @override
  Widget build(BuildContext context) => Container(
        width: _kPublishButtonSize,
        height: _kPublishButtonSize,
        margin: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            color: DiscuzApp.themeOf(context).primaryColor,
            borderRadius: const BorderRadius.all(const Radius.circular(60))),
        child: const ForumAddButton(
          padding: const EdgeInsets.all(0),
          awalysDark: true,
        ),
      );
}

class NavigatorItem {
  /// 图标
  final dynamic icon;

  /// 图标默认颜色
  final Color color;

  /// 是否需要登录才能查看
  final bool shouldLogin;

  /// 图标大小
  final double size;

  /// 是否是发布按钮
  final bool isPublishButton;

  const NavigatorItem(
      {this.icon,
      this.color,
      this.shouldLogin = false,
      this.size = 25.0,
      this.isPublishButton = false});
}
