import 'dart:convert';

import 'package:flutter/material.dart';

class BuildInfoModel {
  ///
  /// 主域名
  ///
  final String domain;

  ///
  /// APP名称
  final String appname;

  ///
  /// 是否显示pdebugShowCheckedModeBanner
  final bool debugShowCheckedModeBanner;

  ///
  /// 是否显示performance Overlay
  final bool enablePerformanceOverlay;

  ///
  /// 是否显示performance Overlay
  final bool enableHttp2;

  ///
  /// 无法校验的证书，是否继续请求
  final bool onBadCertificate;

  ///
  /// 金融功能
  final bool financial;

  ///
  /// http2 idleTimeout
  /// idleTimeout
  final int idleTimeout;

  /// bugly配置
  final dynamic bugly;

  const BuildInfoModel(
      {this.domain = 'https://discuz.chat',
      this.appname = 'DiscuzQ',
      this.enableHttp2 = false,
      this.onBadCertificate = true,
      this.financial = false,
      this.idleTimeout = 15000,
      this.bugly,
      this.debugShowCheckedModeBanner = false,
      this.enablePerformanceOverlay = false});

  ///
  /// fromMap
  /// 转换模型
  ///
  static BuildInfoModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const BuildInfoModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    /// 数据来自json
    return BuildInfoModel(
        domain: data['domain'] ?? '',
        appname: data['appname'] ?? '',
        enableHttp2: data['enableHttp2'] ?? false,
        onBadCertificate: data['onBadCertificate'] ?? true,
        idleTimeout: data['idleTimeout'] ?? 15000,
        financial: data['financial'] ?? false,
        bugly: data['bugly'] ?? null,
        debugShowCheckedModeBanner: data['debugShowCheckedModeBanner'] ?? false,
        enablePerformanceOverlay: data['enablePerformanceOverlay'] ?? false);
  }
}
