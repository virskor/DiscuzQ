import 'package:core/widgets/webview/webviewHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

import 'package:core/utils/bugly.dart';
import 'package:core/widgets/events/globalEvents.dart';

import '../common/discuzDialog.dart';

class Upgrader extends StatefulWidget {
  const Upgrader({Key key, this.child, this.isManual = false})
      : super(key: key);

  final Widget child;

  final bool isManual;
  @override
  _UpgraderState createState() => _UpgraderState();
}

class _UpgraderState extends State<Upgrader> {
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
    this._initBugly();
  }

  @override
  void dispose() {
    DiscuzBugly.dispose();
    super.dispose();
  }

  /// 加载本地的配置
  Future<void> _initBugly() async {
    /// 初始化
    DiscuzBugly.init().then((result) async {
      print({
        "-------------BUGLY-------------",
        result.appId,
        result.isSuccess,
        result.message
      });

      DiscuzBugly.onCheckUpgrade.listen((UpgradeInfo _upgradeInfo) {
        _showUpdateDialog(_upgradeInfo.newFeature, _upgradeInfo.apkUrl,
            _upgradeInfo.upgradeType == 2);
      });

      /// 检测更新
      /// 手动模式下不提示
      if (widget.isManual) {
        this._bindingWantUpgradeEvent();
        return;
      }
      await DiscuzBugly.checkUpdate();
    });
  }

  /// 监听请求更新事件
  void _bindingWantUpgradeEvent() {
    eventBus.on<WantUpgradeAppVersion>().listen((event) {
      DiscuzBugly.checkUpdate(isManual: true);
    });
  }

  /// 弹出更新弹窗
  void _showUpdateDialog(String version, String url, bool isForceUpgrade) =>
      DiscuzDialog.confirm(
          context: context,
          title: "有新版啦",
          message: version,
          onConfirm: () async {
            await WebviewHelper.launchUrl(url: url);
          });

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
