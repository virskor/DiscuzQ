import 'package:discuzq/utils/authHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/ui/ui.dart';

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
    return ScopedModelDescendant<AppModel>(
        rebuildOnChange: false,
        builder: (context, child, model) {
          return RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 270,),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor,
                border: model.appConf['darkTheme'] == true
                    ? null
                    : const Border(top: Global.border),
              ),
              child: _buildItems(model: model),
            ),
          );
        });
  }

  Widget _buildItems({AppModel model}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.items.map<Widget>((it) {
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
                  context: context, model: model);
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

class NavigatorItem {
  /// 图标
  final dynamic icon;

  /// 图标默认颜色
  final Color color;

  /// 是否需要登录才能查看
  final bool shouldLogin;

  /// 图标大小
  final double size;

  const NavigatorItem(
      {this.icon, this.color, this.shouldLogin = false, this.size = 25.0});
}
