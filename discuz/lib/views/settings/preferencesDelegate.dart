import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/settings/settingToolkit.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';
import 'package:discuzq/widgets/settings/clearCache.dart';

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
  Widget build(BuildContext context) => ScopedModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '偏好设置',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: ListView(
              children: <Widget>[
                SettingGroupWrapper(
                  label: '主题与色彩',
                  children: <Widget>[
                    const ThemeColorSetting(),
                    const SettingSwitcher(
                      settinKey: 'darkTheme',
                      icon: SFSymbols.moon,
                      label: '黑暗模式',
                    )
                  ],
                ),
                SettingGroupWrapper(
                  label: '应用数据',
                  children: <Widget>[
                    SettingTile(
                      icon: SFSymbols.square_stack_3d_down_dottedline,
                      label: '清除缓存',
                      onPressed: () {
                        ClearCacheDialog.build(context: context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ));
}
