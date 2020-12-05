import 'dart:convert';

import 'package:core/utils/localstorage.dart';

class AuthorizationHelper {
  /// 用于获取 acesstoken
  static const String authorizationKey = "authorizationKey";

  /// 用于获取refresh token
  static const String refreshTokenKey = "refreshTokenKey";

  /// 当读本地存储的用户信息时
  static const String userKey = "userKey";

  ///
  /// 获取api token
  Future<String> getToken({String key = authorizationKey}) async {
    return await DiscuzLocalStorage.getString(key);
  }

  ///
  /// 取得用户信息
  ///
  Future<dynamic> getUser({String key = userKey}) async {
    final dynamic data = await DiscuzLocalStorage.getString(key);
    if (data == null) {
      return Future.value(null);
    }
    return Future.value(jsonDecode(data));
  }

  ///
  /// 刷新token
  ///
  Future<dynamic> update({dynamic data, String key = authorizationKey}) async {
    final dynamic u = await DiscuzLocalStorage.setString(
        key, data.runtimeType == String ? data : jsonEncode(data));
    if (u == null) {
      return Future.value(null);
    }
    return Future.value(jsonDecode(u));
  }

  ///
  /// 清除token
  ///
  Future<bool> clear() async {
    await DiscuzLocalStorage.clear();
    return Future.value(true);
  }

  ///
  /// 保存认证
  ///
  Future<void> save({dynamic data, String key = authorizationKey}) async {
    await DiscuzLocalStorage.setString(key, data.runtimeType == String ? data : jsonEncode(data));
  }

  Future<void> clearAll() async {
    await DiscuzLocalStorage.clear();
  }
}
