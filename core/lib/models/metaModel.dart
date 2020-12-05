import 'dart:convert';
import 'package:flutter/material.dart';

class MetaModel {
  ///
  /// 主题个数
  final int threadCount;

  ///
  /// 页面总数
  final int pageCount;

  ///
  /// 记录总数
  final int total;

  MetaModel({this.threadCount = 0, this.pageCount = 0, this.total = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static MetaModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return MetaModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return MetaModel(
      total: data['total'] == null
          ? 0
          : data['total'].runtimeType == String
              ? int.tryParse(data['total'])
              : data['total'],
      threadCount: data['threadCount'] == null
          ? 0
          : data['threadCount'].runtimeType == String
              ? int.tryParse(data['threadCount'])
              : data['threadCount'],
      pageCount: data['pageCount'] == null
          ? 0
          : data['pageCount'].runtimeType == String
              ? int.tryParse(data['pageCount'])
              : data['pageCount'],
    );
  }
}
