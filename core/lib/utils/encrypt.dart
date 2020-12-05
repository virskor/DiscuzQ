import 'package:flutter_des/flutter_des.dart';

import 'package:core/utils/global.dart';

class Encrypt {
  /// DES加密
  /// key iv 是可选值
  /// 
  static Future<String> encrypt(String data, {String key, String iv}) =>
      FlutterDes.encryptToBase64(data, key ?? Global.encryptKey,
          iv: iv ?? Global.encryptIV);

  /// DES解密
  static Future<String> decrypt(String data, {String key, String iv}) =>
      FlutterDes.decryptFromBase64(data, key ?? Global.encryptKey,
          iv: iv ?? Global.encryptIV);
}
