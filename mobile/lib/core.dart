library core;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

import 'package:discuzq/discuz.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/appWrapper.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/widgets/emoji/emojiSync.dart';
import 'package:discuzq/providers/appConfigProvider.dart';
import 'package:discuzq/providers/userProvider.dart';
import 'package:discuzq/providers/forumProvider.dart';
import 'package:discuzq/providers/categoriesProvider.dart';
import 'package:discuzq/providers/editorProvider.dart';
import 'package:discuzq/widgets/update/upgrader.dart';
import 'package:discuzq/widgets/settings/privacyConfirm.dart';

///
/// 执行
void runDiscuzApp() {
  FlutterBugly.postCatchedException(
    () => runApp(
      MultiProvider(
        providers: [
          /// APP 配置状态
          ChangeNotifierProvider(create: (_) => AppConfigProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ForumProvider()),
          ChangeNotifierProvider(create: (_) => CategoriesProvider()),
          ChangeNotifierProvider(create: (_) => EditorProvider()),
        ],
        child: DiscuzQ(),
      ),
    ),
  );
}

class DiscuzQ extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Consumer<AppConfigProvider>(
      builder: (BuildContext context, AppConfigProvider conf, Widget child) =>
          AppWrapper(
            onDispose: () {},
            onInit: () async {
              await BuildInfo().init();
              await _initApp(
                context: context,
              );

              ///
              ///
              /// 异步加载表情数据，不用在乎结果，因为这是个单例，客户端再次调用时，会重新尝试缓存
              Future.delayed(Duration.zero).then((_) async {
                await EmojiSync().getEmojis();
              });
            },

            /// 创建入口APP
            child: conf.appConf == null
                ? const _DiscuzAppIndicator()
                : const Upgrader(child: const Discuz()),
          ));

  ///
  /// Init app and states
  /// Future builder to makesure appstate init only once
  Future<void> _initApp({BuildContext context}) async {
    await _initAppSettings();

    ///
    /// 如果appconf还没有成功加载则创建初始化页面 并执行APP初始化
    /// 初始化页面会有loading 圈圈
    /// 同步本地配置状态
    await context.read<AppConfigProvider>().update();

    /// 加载本地的用户信息
    await AuthHelper.getUserFromLocal(context: context);

    await _userPrivaciesNotice(context);
  }

  /// 加载本地的配置
  Future<bool> _initAppSettings() async =>
      await AppConfigurations().initAppSetting();


  /// 弹出用户隐私提示
  void _userPrivaciesNotice(BuildContext context) {
    final dynamic appConf = context.read<AppConfigProvider>().appConf;
    if (appConf['confrimedPrivacy'] != null &&
        appConf['confrimedPrivacy'] == false) {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return const PrivacyConfirm();
          });
    }
  }
}

///
/// loading
class _DiscuzAppIndicator extends StatelessWidget {
  const _DiscuzAppIndicator();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        color: Colors.white,
        home: const DiscuzIndicator(
          brightness: Brightness.dark,
        ),
      );

      
}
