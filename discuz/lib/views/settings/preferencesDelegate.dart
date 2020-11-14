import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:discuzq/widgets/settings/settingToolkit.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';
import 'package:discuzq/widgets/settings/clearCache.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/utils/global.dart';

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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '偏好设置',
              brightness: Brightness.light,
            ),
            body: ListView(
              children: <Widget>[
                SettingGroupWrapper(
                  label: '视觉',
                  children: <Widget>[
                    const ThemeColorSetting(),
                    const SettingSwitcher(
                      settinKey: 'darkTheme',
                      icon: CupertinoIcons.moon,
                      label: '黑暗模式',
                    ),

                    ///
                    /// 仅在用户允许使用的时候才开启
                    /// build.yaml中进行开关
                    BuildInfo().info().enablePerformanceOverlay
                        ? const SettingSwitcher(
                            settinKey: 'showPerformanceOverlay',
                            icon: CupertinoIcons.graph_circle,
                            label: '性能调试工具',
                          )
                        : const SizedBox()
                  ],
                ),
                SettingGroupWrapper(
                  label: '应用',
                  children: <Widget>[
                    const SettingSwitcher(
                      settinKey: 'autoplay',
                      icon: CupertinoIcons.videocam_circle,
                      label: '自动播放视频',
                    ),
                    const SettingSwitcher(
                      settinKey: 'hideContentRequirePayments',
                      icon: CupertinoIcons.money_dollar_circle,
                      label: '不看受保护的内容',
                    ),
                    SettingTile(
                      icon: 0xe66b,
                      label: '清除缓存',
                      onPressed: () {
                        ClearCacheDialog.build(context: context);
                      },
                    ),
                  ],
                ),
                SettingGroupWrapper(
                  label: '信息',
                  children: <Widget>[
                    SettingTile(
                        icon: CupertinoIcons.info_circle,
                        label: '关于APP',
                        onPressed: () => WebviewHelper.open(context,
                            url: "${Global.domain}/pages/site/index",
                            shouldLogin: true,
                            title: '关于')),
                  ],
                ),
              ],
            ),
          ));
}
