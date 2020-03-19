import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/states/scopedState.dart';

///
/// notice: 使用SettingSwitcher 进行设置的选项，值必须是bool，否则将出错
///
class SettingSwitcher extends StatelessWidget {
  final String settinKey;
  final IconData icon;
  final String label;

  const SettingSwitcher(
      {@required this.settinKey, @required this.icon, @required this.label});
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Container(
            child: DiscuzListTile(
                leading: DiscuzIcon(icon),
                title: DiscuzText(label),
                trailing: Switch.adaptive(
                  value: state.appConf[settinKey],
                  onChanged: (bool val) => AppConfigurations().update(
                      context: context,
                      key: 'darkTheme',
                      value: !state.appConf['darkTheme']),
                )),
          ));
}

///
/// 设置Tile 通常传入function可以调用function
///
class SettingTile extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String label;

  const SettingTile(
      {@required this.onPressed, @required this.icon, @required this.label});
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Container(
            child: DiscuzListTile(
              leading: DiscuzIcon(icon),
              title: DiscuzText(label),
              onTap: () => onPressed(),
            ),
          ));
}
