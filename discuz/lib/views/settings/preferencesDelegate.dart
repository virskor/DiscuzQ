import 'package:discuzq/widgets/settings/settingSwitcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';

class PreferencesDelegate extends StatefulWidget {
  const PreferencesDelegate({Key key}) : super(key: key);
  @override
  _PreferencesDelegateState createState() => _PreferencesDelegateState();
}

class _PreferencesDelegateState extends State<PreferencesDelegate> {
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
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              elevation: 10,
              centerTitle: true,
              title: '偏好设置',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: ListView(
              children: <Widget>[
                SettingGroupWrapper(
                  label: '主题与色彩',
                  children: <Widget>[
                    const ThemeColorSetting(),
                    const SettingSwitcher(settinKey: 'darkTheme', icon: SFSymbols.moon, label: '黑暗模式',)
                  ],
                ),
              ],
            ),
          ));
}
