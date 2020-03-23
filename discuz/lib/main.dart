import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/discuz.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/appWrapper.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppState appState = AppState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ScopedStateModel<AppState>(
      model: appState,
      child: ScopedStateModelDescendant<AppState>(builder: (context, child, state) {
        return AppWrapper(
          onDispose: () {},
          onInit: () async{
            // 加载配置文件
            await this.initAppSettings();

            ///
            /// 如果appconf还没有成功加载则创建初始化页面 并执行APP初始化
            /// 初始化页面会有loading 圈圈
            if (state.appConf == null) {
              _initAppState(state);
            }

            /// 加载本地的用户信息
            AuthHelper.getUserFromLocal(state: state);
          },

          /// 创建入口APP
          child: state.appConf == null
              ? const Center(child: const DiscuzIndicator())
              : const Discuz(),
        );
      }));

  /// 将本地的配置转换为APP的状态
  Future<void> _initAppState(AppState state) async =>
      state.initAppConf(await AppConfigurations()
          .getLocalAppSetting(returnDefaultValueIfNotExits: true));

  /// 加载本地的配置
  Future<void> initAppSettings() async =>
      await AppConfigurations().initAppSetting();
}
