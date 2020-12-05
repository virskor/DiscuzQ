import 'dart:convert';
import 'package:flutter/material.dart';

class EmojiModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final int type;

  ///
  /// 关联数据
  ///
  final EmojiAttributesModel attributes;

  const EmojiModel({this.id = 0, this.type = 0, this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static EmojiModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const EmojiModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return EmojiModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] == null
            ? 0
            : data['type'].runtimeType == String
                ? int.tryParse(data['type'])
                : data['type'],
        attributes: data['attributes'] == null
            ? const EmojiAttributesModel()
            : EmojiAttributesModel.fromMap(maps: data['attributes']));
  }
}

class EmojiAttributesModel {
  ///
  /// 分类
  ///
  final String category;

  ///
  /// url
  /// 图片链接
  final String url;

  ///
  /// code
  /// 表情代码
  final String code;

  ///
  /// order
  /// 排序
  final int order;

  const EmojiAttributesModel(
      {this.category = '', this.url = '', this.code = '', this.order = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static EmojiAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const EmojiAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return EmojiAttributesModel(
      order: data['order'] == null
          ? 0
          : data['order'].runtimeType == String
              ? int.tryParse(data['order'])
              : data['order'],
      url: data['url'] ?? '',
      code: data['code'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
