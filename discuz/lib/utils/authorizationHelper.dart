import 'dart:convert';

import 'package:discuzq/db/user.dart';
import 'package:discuzq/utils/device.dart';
import 'package:discuzq/utils/localstorage.dart';

class AuthorizationHelper {
  /// 用于获取 acesstoken
  static const authorizationKey = 1;

  /// 用于获取refresh token
  static const refreshTokenKey = 3;

  /// 当读本地存储的用户信息时
  static const userKey = 2;

  ///
  /// 取得token
  ///
  final UserDataSqlite _userDataSqlite = UserDataSqlite();

  ///
  /// 获取api token
  Future<String> getToken({int key = authorizationKey}) async {
    if (FlutterDevice.isWeb) {
      return DiscuzLocalStorage.getString(key.toString());
    }

    await _userDataSqlite.openSqlite();
    UserDBModel user = await _userDataSqlite.queryByID(key);
    _userDataSqlite.close();

    if (user == null) {
      return Future.value(null);
    }

    return Future.value(user.data.toString());
  }

  ///
  /// 取得用户信息
  ///
  Future<dynamic> getUser({int key = userKey}) async {
    if (FlutterDevice.isWeb) {
      final dynamic data = await DiscuzLocalStorage.getString(key.toString());
      return Future.value(jsonDecode(data));
    }

    await _userDataSqlite.openSqlite();
    UserDBModel user = await _userDataSqlite.queryByID(key);
    await _userDataSqlite.close();

    if (user == null) {
      return Future.value(null);
    }

    return Future.value(user.data);
  }

  ///
  /// 刷新token
  ///
  Future<UserDBModel> update({dynamic data, int key = authorizationKey}) async {
    if (FlutterDevice.isWeb) {
      final dynamic u =
          await DiscuzLocalStorage.setString(key.toString(), jsonEncode(data));
      return Future.value(jsonDecode(u));
    }

    await _userDataSqlite.openSqlite();
    UserDBModel user = await _userDataSqlite.update(
        UserDBModel(key, data.runtimeType == String ? data : jsonEncode(data)));
    await _userDataSqlite.close();
    return Future.value(user);
  }

  ///
  /// 清除token
  ///
  Future<bool> clear({int key = authorizationKey}) async {
    if (FlutterDevice.isWeb) {
      return DiscuzLocalStorage.clear();
    }
    await _userDataSqlite.openSqlite();
    await _userDataSqlite.remove(key);
    await _userDataSqlite.close();
    return Future.value(true);
  }

  ///
  /// 保存认证
  ///
  Future<UserDBModel> save({dynamic data, int key = authorizationKey}) async {
    if (FlutterDevice.isWeb) {
      final dynamic a =
          await DiscuzLocalStorage.setString(key.toString(), jsonEncode(data));
      return Future.value(jsonDecode(a));
    }

    await _userDataSqlite.openSqlite();

    /// 判断是更新，还是新入保存
    UserDBModel find = await _userDataSqlite.queryByID(key);
    if (find != null) {
      UserDBModel user = await update(key: key, data: data);

      /// update会自己去编码
      return Future.value(user);
    }

    // 新入
    UserDBModel user = await _userDataSqlite.insert(
        UserDBModel(key, data.runtimeType == String ? data : jsonEncode(data)));
    await _userDataSqlite.close();
    return Future.value(user);
  }

  Future<void> clearAll() async {
    if (FlutterDevice.isWeb) {
      return DiscuzLocalStorage.clear();
    }
    await _userDataSqlite.clearAll();
  }
}
