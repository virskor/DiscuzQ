import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:core/utils/localstorage.dart';

class AppConfigurations {
  static const _appConfKey = 'appConf';

  final Map<String, dynamic> defaultAppSetting = {
    "darkTheme": false,
    "themeColor": 0xFF007AFF,
    "fontWidthFactor": 0.95,
    "showPerformanceOverlay": false,
    "autoplay": true,
    "hideContentRequirePayments": true,
  };

  Future<dynamic> update(
      {String key,
      dynamic value,
      BuildContext context,
      bool reverse = false,
      bool rebuildOnChange = true}) async {
    /// reverse to default app settings
    if (reverse == true) {
      await DiscuzLocalStorage.setString(
          _appConfKey, jsonEncode(defaultAppSetting));
      return Future.value(true);
    }

    /// validate keys
    if (key == null) {
      return Future.value(false);
    }

    /// should convert DateTime to String before changing
    /// Datetime can not be converted into json automatically
    if (value.runtimeType == DateTime) {
      value = value.toString();
    }

    /// modify localData
    final Map<String, dynamic> item = {
      key: value,
    };

    /// get lasted modified appSetting and replace
    dynamic localAppSetting =
        await getLocalAppSetting(returnDefaultValueIfNotExits: true);
    localAppSetting.addAll(item);

    /// modify local settings
    await _modifyLocalSetting(appConf: localAppSetting);

    return localAppSetting;
  }

  /// call initAppSetting when Appliation start to run
  /// this methods only available for running application at first time
  Future<bool> initAppSetting() async {
    final dynamic appconf = await getLocalAppSetting();
    if (appconf != null) {
      return Future.value(false);
    }

    return DiscuzLocalStorage.setString(
        _appConfKey, jsonEncode(defaultAppSetting));
  }

  /// modify localstorage app setting
  Future<bool> _modifyLocalSetting({@required dynamic appConf}) async {
    return DiscuzLocalStorage.setString(_appConfKey, jsonEncode(appConf));
  }

  /// return dynamic data
  Future<dynamic> getLocalAppSetting(
      {bool returnDefaultValueIfNotExits = false}) async {
    final String appconf = await DiscuzLocalStorage.getString(_appConfKey);

    if (appconf == null && returnDefaultValueIfNotExits == false) {
      return Future.value(null);
    }

    if (appconf == null && returnDefaultValueIfNotExits == true) {
      return Future.value(defaultAppSetting);
    }

    /// modify application state if default conf added new item
    dynamic conf = jsonDecode(appconf);
    defaultAppSetting.addAll(conf);

    return Future.value(defaultAppSetting);
  }
}
