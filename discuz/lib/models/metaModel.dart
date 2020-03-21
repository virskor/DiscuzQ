import 'dart:convert';
import 'package:flutter/material.dart';

class MetaModel {
  final int threadCount;

  final int pageCount;

  MetaModel({this.threadCount = 0, this.pageCount = 0});

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
