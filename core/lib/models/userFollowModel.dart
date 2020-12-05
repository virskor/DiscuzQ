import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:core/models/relationShipsModel.dart';

class UserFollowModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final String type;

  ///
  /// relationships
  /// 关联数据
  final RelationshipsModel relationships;

  ///
  /// 关联信息
  ///
  final UserFollowAttributesModel attributes;

  const UserFollowModel(
      {this.id = 0,
      this.type = 'user_follow',
      this.relationships,
      this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserFollowModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserFollowModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return UserFollowModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] ?? 'user_follow',
        relationships: data['relationships'] == null
            ? RelationshipsModel()
            : RelationshipsModel.fromMap(maps: data['relationships']),
        attributes: data['attributes'] == null
            ? const UserFollowAttributesModel()
            : UserFollowAttributesModel.fromMap(maps: data['attributes']));
  }
}

class UserFollowAttributesModel {
  ///
  /// id
  final int id;

  ///
  /// from_user_id
  /// 关注我的人UID
  final int fromUserID;

  ///
  /// to_user_id
  /// 我关注的人UID
  final int toUserID;

  ///
  /// is_mutual
  /// 是否互相关注
  final int isMutual;

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

  const UserFollowAttributesModel(
      {this.id = 0,
      this.fromUserID = 0,
      this.toUserID = 0,
      this.isMutual = 0,
      this.createdAt = '',
      this.updatedAt = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserFollowAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserFollowAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return UserFollowAttributesModel(
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      id: data['id'] == null
          ? 0
          : data['id'].runtimeType == String
              ? int.tryParse(data['id'])
              : data['id'],
      fromUserID: data['from_user_id'] == null
          ? 0
          : data['from_user_id'].runtimeType == String
              ? int.tryParse(data['from_user_id'])
              : data['from_user_id'],
      toUserID: data['to_user_id'] == null
          ? 0
          : data['to_user_id'].runtimeType == String
              ? int.tryParse(data['to_user_id'])
              : data['to_user_id'],
      isMutual: data['to_user_id'] == null
          ? 0
          : data['is_mutual'].runtimeType == String
              ? int.tryParse(data['is_mutual'])
              : data['is_mutual'],
    );
  }
}
