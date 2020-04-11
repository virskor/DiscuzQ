import 'dart:convert';
import 'package:flutter/material.dart';

///
/// 用户组模型
class UserGroupModel {
  ///
  /// 类型
  ///
  final String type;

  ///
  /// 用户组ID
  final int id;

  ///
  /// 关联的信息
  final UserGroupModelAttributes attributes;

  const UserGroupModel(
      {this.type = 'groups',
      this.id = 0,
      this.attributes = const UserGroupModelAttributes()});

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserGroupModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserGroupModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return UserGroupModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] ?? 'groups',
        attributes: data['attributes'] == null
            ? const UserGroupModelAttributes()
            : UserGroupModelAttributes.fromMap(maps: data['attributes']));
  }
}

class UserGroupModelAttributes {
  ///
  /// 用户组名称
  ///
  final String name;

  ///
  /// 用户组类型
  ///
  final String type;

  ///
  /// 用户组渲染颜色
  /// 指指定用户名标签渲染颜色
  ///
  final String color;

  ///
  /// 图标Url
  ///
  final String icon;

  ///
  /// 是否是默认用户组
  /// 由于default是保留关键字，这里更名为defaultGroup 记住，绑定的值还是传入的default
  ///
  final bool defaultGroup;

  const UserGroupModelAttributes(
      {this.name = '',
      this.type = '',
      this.color = '',
      this.icon,
      this.defaultGroup = false});

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserGroupModelAttributes fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserGroupModelAttributes();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return UserGroupModelAttributes(
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      color: data['color'] ?? '',
      icon: data['icon'] ?? '',
      defaultGroup: data['default'] ?? false,
    );
  }
}
