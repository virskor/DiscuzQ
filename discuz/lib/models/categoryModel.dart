import 'dart:convert';
import 'package:flutter/material.dart';

class CategoryModel {
  ///
  /// id
  /// 分类的ID
  ///
  final int id;

  ///
  /// type
  /// 类型
  ///
  final String type;

  ///
  /// attributes
  /// 关联数据
  ///
  final CategoryModelAttributes attributes;

  ///
  /// 分类模型
  ///
  const CategoryModel({this.id = 0, this.type = 'categories', this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static CategoryModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const CategoryModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return CategoryModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'],
        attributes: data['attributes'] == null
            ? const CategoryModelAttributes()
            : CategoryModelAttributes.fromMap(maps: data['attributes']));
  }
}

class CategoryModelAttributes {
  ///
  /// name
  /// 分类的名称
  ///
  final String name;

  ///
  /// description
  /// 分类的描述
  ///
  final String description;

  ///
  /// icon
  /// 图标URl
  ///
  final String icon;

  ///
  /// sort
  /// 排序
  ///
  final int sort;

  ///
  /// property
  /// 属性：0:正常 1:首页展示
  ///
  final int property;

  ///
  /// thread_count
  /// 帖子数量
  final int threadCount;

  ///
  /// ip
  ///
  final String ip;

  ///
  /// createdAt
  /// 创建时间
  ///
  final String createdAt;

  ///
  /// updatedAt
  /// 修改时间
  ///
  final String updatedAt;

  /// canCreateThread
  /// 是否有权限新增话题
  final bool canCreateThread;

  /// canReplyThread
  /// 是否有权限回复
  final bool canReplyThread;

  /// canViewThreads
  /// 是否有权查看该分类
  final bool canViewThreads;

  ///
  /// 分类属性
  const CategoryModelAttributes(
      {this.name = "",
      this.icon = "",
      this.description = "",
      this.sort = 0,
      this.threadCount = 0,
      this.createdAt = "",
      this.updatedAt = "",
      this.ip = "",
      this.canCreateThread = false,
      this.canReplyThread = true,
      this.canViewThreads = true,
      this.property = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static CategoryModelAttributes fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const CategoryModelAttributes();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return CategoryModelAttributes(
        name: data['name'] ?? '',
        icon: data['icon'] ?? '',
        description: data['description'] ?? '',
        sort: data['sort'] ?? 0,
        property: data['property'] ?? 0,
        threadCount: data['thread_count'] ?? 0,
        createdAt: data['created_at'] ?? '',
        updatedAt: data['updated_at'] ?? '',
        canCreateThread: data['canCreateThread'] ?? false,
        canReplyThread: data['canReplyThread'] ?? true,
        canViewThreads: data['canViewThreads'] ?? true,
        ip: data['ip'] ?? '');
  }
}
