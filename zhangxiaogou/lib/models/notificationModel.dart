import 'dart:convert';
import 'package:flutter/material.dart';

///
/// 通知模型
class NotificationModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final int type;

  final NotificationAttributesModel attributes;

  const NotificationModel({this.id = 0, this.type = 0, this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static NotificationModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const NotificationModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return NotificationModel(
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
            ? const NotificationAttributesModel()
            : NotificationAttributesModel.fromMap(maps: data['attributes']));
  }
}

class NotificationAttributesModel {
  ///
  /// id
  /// 通知的ID
  final int id;

  ///
  /// createdAt
  /// 创建时间
  ///
  final String createdAt;

  ///
  /// updatedAt
  /// 修改时间
  ///
  final String readAt;

  ///
  /// user_name
  /// 用户名 指对方的用户名
  final String username;

  ///
  /// post_content
  /// 回复的内容
  final String postContent;

  ///
  /// post_content
  /// 回复的内容(模板)
  final String content;

  ///
  /// post_id
  /// 关联的PostID
  final int postID;

  ///
  /// thread_id
  /// 关联的主题ID
  final int threadID;

  ///
  /// thread_title
  /// 关联的主题标题
  final String threadTitle;

  ///
  /// thread_is_approved
  /// 关联的主题是否通过审核
  final int threadIsApproved;

  ///
  /// title
  /// 通知标题
  final String title;

  ///
  /// user_avatar
  /// 关联的用户头像 指对方账户的头像，也就是回复发起人
  final String userAvatar;

  ///
  /// user_id
  /// 发起回复用户的ID
  final int userID;

  const NotificationAttributesModel(
      {this.id = 0,
      this.postID = 0,
      this.threadID = 0,
      this.userID = 0,
      this.threadIsApproved = 0,
      this.createdAt = '',
      this.readAt = '',
      this.threadTitle = '',
      this.title = '',
      this.username = '',
      this.content = '',
      this.userAvatar = '',
      this.postContent = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static NotificationAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const NotificationAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return NotificationAttributesModel(
      id: data['id'] == null
          ? 0
          : data['id'].runtimeType == String
              ? int.tryParse(data['id'])
              : data['id'],
      userID: data['user_id'] == null
          ? 0
          : data['user_id'].runtimeType == String
              ? int.tryParse(data['user_id'])
              : data['user_id'],
      threadID: data['thread_id'] == null
          ? 0
          : data['thread_id'].runtimeType == String
              ? int.tryParse(data['thread_id'])
              : data['thread_id'],
      threadTitle: data['thread_title'] ?? '',
      threadIsApproved: data['thread_is_approved'] ?? '',
      userAvatar: data['user_avatar'] ?? '',
      username: data['user_name'] ?? '',
      createdAt: data['created_at'] ?? '',
      readAt: data['read_at'] ?? '',
      title: data['title'] ?? '',
      postContent: data['post_content'] ?? '',
      content: data['content'] ?? '',
      postID: data['post_id'] == null
          ? 0
          : data['post_id'].runtimeType == String
              ? int.tryParse(data['post_id'])
              : data['post_id'],
    );
  }
}
