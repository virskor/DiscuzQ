import 'dart:convert';

import 'package:discuzq/utils/localstorage.dart';

class AuthorizationHelper {
  /// 用于获取 acesstoken
  static const authorizationKey = 1;

  /// 用于获取refresh token
  static const refreshTokenKey = 3;

  /// 当读本地存储的用户信息时
  static const userKey = 2;

  ///
  /// 获取api token
  Future<String> getToken({int key = authorizationKey}) async {
    return await DiscuzLocalStorage.getString(key.toString());
  }

  ///
  /// 取得用户信息
  ///
  Future<dynamic> getUser({int key = userKey}) async {
    final dynamic data = await DiscuzLocalStorage.getString(key.toString());
    return Future.value(jsonDecode(data));
  }

  ///
  /// 刷新token
  ///
  Future<dynamic> update({dynamic data, int key = authorizationKey}) async {
    final dynamic u =
        await DiscuzLocalStorage.setString(key.toString(), jsonEncode(data));
    return Future.value(jsonDecode(u));
  }

  ///
  /// 清除token
  ///
  Future<bool> clear({int key = authorizationKey}) async {
    await DiscuzLocalStorage.clear();
    return Future.value(true);
  }

  ///
  /// 保存认证
  ///
  Future<dynamic> save({dynamic data, int key = authorizationKey}) async {
    final dynamic a =
        await DiscuzLocalStorage.setString(key.toString(), jsonEncode(data));
    return Future.value(jsonDecode(a));
  }

  Future<void> clearAll() async {
    await DiscuzLocalStorage.clear();
  }
}
