import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/settings/settingToolkit.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';
import 'package:discuzq/widgets/settings/clearCache.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/settings/aboutDelegate.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';

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
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: ListView(
              children: <Widget>[
                SettingGroupWrapper(
                  label: '视觉',
                  children: <Widget>[
                    const ThemeColorSetting(),
                    const SettingSwitcher(
                      settinKey: 'darkTheme',
                      icon: SFSymbols.moon,
                      label: '黑暗模式',
                    ),

                    ///
                    /// 仅在用户允许使用的时候才开启
                    /// build.yaml中进行开关
                    BuildInfo().info().enablePerformanceOverlay
                        ? const SettingSwitcher(
                            settinKey: 'showPerformanceOverlay',
                            icon: SFSymbols.graph_circle,
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
                      icon: SFSymbols.videocam_circle,
                      label: '自动播放视频',
                    ),
                    const SettingSwitcher(
                      settinKey: 'hideContentRequirePayments',
                      icon: SFSymbols.money_dollar_circle,
                      label: '收起受保护的内容',
                    ),
                    SettingTile(
                      icon: SFSymbols.square_stack_3d_down_dottedline,
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
                        icon: SFSymbols.upload_circle,
                        label: '历史版本记录',
                        onPressed: () =>
                            WebviewHelper.launchUrl(url: Urls.changelog)),
                    BuildInfo().info().tuxiaochao == ''
                        ? const SizedBox()
                        : SettingTile(
                            icon: SFSymbols.text_bubble,
                            label: '吐槽',
                            onPressed: () => WebviewHelper.open(context,
                                url: BuildInfo().info().tuxiaochao,
                                title: '反馈')),
                    SettingTile(
                        icon: SFSymbols.info_circle,
                        label: '关于APP',
                        onPressed: () => DiscuzRoute.open(
                            context: context, widget: const AboutDelegate())),
                  ],
                ),
              ],
            ),
          ));
}
