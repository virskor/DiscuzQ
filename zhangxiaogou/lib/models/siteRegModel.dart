import 'dart:convert';
import 'package:flutter/material.dart';

class SiteRegModel {
  ///
  /// register_close
  /// 1允许0不允许
  /// 是否关闭注册了
  final bool registerClose;

  ///
  /// register_captcha
  /// 1允许0不允许
  /// 是否开启注册验证码
  final bool registerCaptcha;

  ///
  /// register_validate
  /// 1开启 0关闭
  /// 是否开启注册审核
  final bool registerValidate;

  ///
  /// password_length
  /// 密码长度
  /// 默认不填时是6位密码
  final int passwordLength;

  ///
  /// password_strength
  /// 密码强度
  /// 0数字 1小写字母
  /// 2符号 3大写字母
  final List<dynamic> passwordStrength;

  const SiteRegModel(
      {this.registerClose = false,
      this.registerValidate = false,
      this.registerCaptcha = false,
      this.passwordStrength = const [],
      this.passwordLength = 6});

  ///
  /// fromMap
  /// 转换模型
  ///
  static SiteRegModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const SiteRegModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return SiteRegModel(
        registerClose: data['register_close'] ?? false,
        registerValidate: data['register_close'] ?? false,
        registerCaptcha: data['register_captcha'] ?? false,
        passwordLength: data['password_length'] == null
            ? 0
            : data['password_length'].runtimeType == String
                ? int.tryParse(data['password_length'])
                : data['password_length'],
        passwordStrength: data['password_strength'] ?? const []);
  }
}
