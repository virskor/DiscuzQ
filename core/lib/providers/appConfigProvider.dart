import 'package:core/utils/appConfigurations.dart';
import 'package:flutter/foundation.dart';


/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class AppConfigProvider with ChangeNotifier, DiagnosticableTreeMixin {

  /// app config
  dynamic _appConf;
  dynamic get appConf => _appConf;

  /// 更新状态管理
  Future<void> update({
    /// key to save
    String key, 
    /// value to save
    dynamic value, 
    /// will recover all settings to default
    bool reverse = false}) async {
    if (key != null) {
      _appConf = await AppConfigurations()
          .update(key: key, value: value, reverse: reverse);
      notifyListeners();
      return;
    }

    _appConf = await AppConfigurations()
        .getLocalAppSetting(returnDefaultValueIfNotExits: true);
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('appConf', _appConf));
  }
}
