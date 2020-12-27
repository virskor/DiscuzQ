import 'dart:convert';
import 'package:flutter/material.dart';

class AgreementsModel {
  const AgreementsModel(
      {this.privacy = false,
      this.register = false,
      this.privacyContent = "",
      this.registerContent = ""});

  ///
  /// privacy
  /// 是否启用隐私政策
  final bool privacy;

  ///
  /// privacy_content
  /// 隐私政策
  final String privacyContent;

  ///
  /// register
  /// 是否设置使用注册协议
  final bool register;

  ///
  /// register_content
  /// 注册协议
  final String registerContent;

  ///
  /// fromMap
  /// 转换模型
  ///
  static AgreementsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const AgreementsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return AgreementsModel(
      privacy: data['privacy'] ?? false,
      register: data['register'] ?? false,
      privacyContent: data['privacy_content'] ?? false,
      registerContent: data['register_content'] ?? false,
    );
  }
}
