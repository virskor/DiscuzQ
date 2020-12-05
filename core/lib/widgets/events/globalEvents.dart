import 'package:event_bus/event_bus.dart';

/// 在页面中请求切换tab
EventBus eventBus = EventBus();

/// 用户手动点击更新事件
class WantUpgradeAppVersion {
  WantUpgradeAppVersion();
}