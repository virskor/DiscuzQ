import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/providers/appConfigProvider.dart';

///
/// notice: 使用SettingSwitcher 进行设置的选项，值必须是bool，否则将出错
///
class SettingSwitcher extends StatelessWidget {
  final String settingKey;
  final IconData icon;
  final String label;

  const SettingSwitcher(
      {@required this.settingKey, @required this.icon, @required this.label});
  @override
  Widget build(BuildContext context) => Consumer<AppConfigProvider>(
      builder: (BuildContext context, AppConfigProvider conf, Widget child) =>
          Container(
            child: DiscuzListTile(
                leading: DiscuzIcon(icon),
                title: DiscuzText(label),
                trailing: Switch.adaptive(
                  value: conf.appConf[settingKey],
                  onChanged: (bool val) => conf.update(
                      key: settingKey, value: !conf.appConf[settingKey]),
                )),
          ));
}

///
/// 设置Tile 通常传入function可以调用function
///
class SettingTile extends StatelessWidget {
  final Function onPressed;
  final dynamic icon;
  final String label;

  const SettingTile(
      {@required this.onPressed, @required this.icon, @required this.label});
  @override
  Widget build(BuildContext context) => Container(
        child: DiscuzListTile(
          leading: DiscuzIcon(icon),
          title: DiscuzText(label),
          onTap: () => onPressed(),
        ),
      );
}
