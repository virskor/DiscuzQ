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
  /// 是否显示performance Overlay
  final bool enablePerformanceOverlay;

  const BuildInfoModel(
      {this.domain = 'https://discuz.chat',
      this.appname = 'DiscuzQ',
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
        enablePerformanceOverlay: data['enablePerformanceOverlay'] ?? false);
  }
}
