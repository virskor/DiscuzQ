import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/discuz.dart';
import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/appWrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppModel appModel = AppModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ScopedModel<AppModel>(
      model: appModel,
      child: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
        return AppWrapper(
          onDispose: () {},
          onInit: () {
            // 加载配置文件
            this.initAppSettings();

            ///
            /// 如果appconf还没有成功加载则创建初始化页面 并执行APP初始化
            /// 初始化页面会有loading 圈圈
            if (model.appConf == null) {
              _initAppState(model);
            }
          },

          /// 创建入口APP
          child: model.appConf == null
              ? const Center(child: const CupertinoActivityIndicator())
              : const Discuz(),
        );
      }));

  /// 将本地的配置转换为APP的状态
  Future<void> _initAppState(AppModel model) async =>
      model.initAppConf(await AppConfigurations()
          .getLocalAppSetting(returnDefaultValueIfNotExits: true));

  /// 加载本地的配置
  Future<void> initAppSettings() async =>
      await AppConfigurations().initAppSetting();
}
