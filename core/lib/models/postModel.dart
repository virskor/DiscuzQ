import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:core/models/relationShipsModel.dart';

///
/// 评论模型
class PostModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final int type;

  ///
  /// attributes
  /// 评论数据
  final PostAttributesModel attributes;

  ///
  /// relationships
  /// 关联数据
  final RelationshipsModel relationships;

  const PostModel(
      {this.id = 0, this.type = 0, this.attributes, this.relationships});

  ///
  /// fromMap
  /// 转换模型
  ///
  static PostModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const PostModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return PostModel(
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
        relationships: data['relationships'] == null
            ? const RelationshipsModel()
            : RelationshipsModel.fromMap(maps: data['relationships']),
        attributes: data['attributes'] == null
            ? const PostAttributesModel()
            : PostAttributesModel.fromMap(maps: data['attributes']));
  }
}

///
/// PostAttributesModel
class PostAttributesModel {
  ///
  /// replyUserID
  /// 发起回复的用户ID
  final int replyUserID;

  ///
  /// content
  /// 回复的内容
  final String content;

  ///
  /// contentHtml
  /// 回复的内容，转化为HTML后的结果
  final String contentHtml;

  ///
  /// replyCount
  /// 回复条数
  final int replyCount;

  ///
  /// likeCount
  /// 点赞条数
  final int likeCount;

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

  ///
  /// isFirst
  /// 是否是第一条
  final bool isFirst;

  ///
  /// isApproved
  /// 是否合法(审核)
  final int isApproved;

  ///
  /// canDelete
  /// 是否有权永久删除
  final bool canDelete;

  ///
  /// canHide
  /// 是否有权放入回收站
  final bool canHide;

  ///
  /// canHide
  /// 是否有权审核
  final bool canApprove;

  ///
  /// canEdit
  /// 是否有权编辑
  final bool canEdit;

  ///
  /// canLike
  /// 是否有权点赞
  final bool canLike;

  const PostAttributesModel(
      {this.replyUserID = 0,
      this.content = '',
      this.contentHtml = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.isFirst = false,
      this.isApproved = 0,
      this.canDelete = false,
      this.canHide = false,
      this.canApprove = false,
      this.canEdit = false,
      this.replyCount = 0,
      this.canLike = false,
      this.likeCount = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static PostAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const PostAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return PostAttributesModel(
      replyUserID: data['replyUserId'] == null
          ? 0
          : data['replyUserId'].runtimeType == String
              ? int.tryParse(data['replyUserId'])
              : data['replyUserId'],
      content: data['content'] ?? '',
      contentHtml: data['contentHtml'] ?? '',
      replyCount: data['replyCount'] == null
          ? 0
          : data['replyCount'].runtimeType == String
              ? int.tryParse(data['replyCount'])
              : data['replyCount'],
      likeCount: data['likeCount'] == null
          ? 0
          : data['likeCount'].runtimeType == String
              ? int.tryParse(data['likeCount'])
              : data['likeCount'],
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      isFirst: data['isFirst'] ?? false,
      isApproved: data['isApproved'] == null
          ? 0
          : data['isApproved'].runtimeType == String
              ? int.tryParse(data['isApproved'])
              : data['isApproved'],
      canEdit: data['canEdit'] ?? false,
      canApprove: data['canApprove'] ?? false,
      canDelete: data['canDelete'] ?? false,
      canHide: data['canHide'] ?? false,
      canLike: data['canLike'] ?? false,
    );
  }
}
