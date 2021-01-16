import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:discuzq/widgets/settings/settingToolkit.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';
import 'package:discuzq/widgets/settings/clearCache.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/router/routers.dart';
import 'package:discuzq/widgets/update/upgrader.dart';
import 'package:discuzq/widgets/events/globalEvents.dart';
import 'package:discuzq/providers/userProvider.dart';
import 'package:discuzq/widgets/share/shareApp.dart';
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
  Widget build(BuildContext context) => Scaffold(
        appBar: DiscuzAppBar(
          title: '偏好设置',
        ),
        body: ListView(
          children: <Widget>[
            SettingGroupWrapper(
              label: '视觉',
              children: <Widget>[
                const ThemeColorSetting(),
                const SettingSwitcher(
                  settingKey: 'darkTheme',
                  icon: CupertinoIcons.moon,
                  label: '黑暗模式',
                ),

                ///
                /// 仅在用户允许使用的时候才开启
                /// build.yaml中进行开关
                BuildInfo().info().enablePerformanceOverlay
                    ? const SettingSwitcher(
                        settingKey: 'showPerformanceOverlay',
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
                  settingKey: 'autoplay',
                  icon: CupertinoIcons.videocam_circle,
                  label: '自动播放视频',
                ),
                const SettingSwitcher(
                  settingKey: 'hideContentRequirePayments',
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
                Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider user, Widget child) =>SettingTile(
                  icon: 0xe6cd,
                  label: '邀请好友',
                  onPressed: () {
                    ShareApp.show(context: context, user: user.user);
                  },
                ),),
              ],
            ),
            SettingGroupWrapper(
              label: '信息',
              children: <Widget>[
                Platform.isAndroid
                    ? Upgrader(
                        child: SettingTile(
                            icon: 0xe80d,
                            label: '获取新版',
                            onPressed: () =>
                                eventBus.fire(const WantUpgradeAppVersion())),
                        isManual: true)
                    : const SizedBox(),
                BuildInfo().info().technicalSupport == ""
                    ? const SizedBox()
                    : SettingTile(
                        icon: 0xe683,
                        label: '技术支持',
                        onPressed: () {
                          WebviewHelper.launchUrl(
                              url: BuildInfo().info().technicalSupport);
                        }),
                BuildInfo().info().helpCenter == ""
                    ? const SizedBox()
                    : SettingTile(
                        icon: CupertinoIcons.question_circle,
                        label: '获得帮助',
                        onPressed: () {
                          WebviewHelper.launchUrl(
                              url: BuildInfo().info().helpCenter);
                        }),
                SettingTile(
                    icon: CupertinoIcons.info_circle,
                    label: '关于APP',
                    onPressed: () {
                      DiscuzRoute.navigate(
                        context: context,
                        path: Routers.about,
                      );
                    }),
              ],
            ),
          ],
        ),
      );
}
