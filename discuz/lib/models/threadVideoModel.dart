import 'dart:convert';

import 'package:flutter/material.dart';

class ThreadVideoModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final String type;

  ///
  /// 主题信息
  ///
  final ThreadVideoAttributeModel attributes;

  const ThreadVideoModel(
      {this.id = 0, this.type = 'thread-video', this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ThreadVideoModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const ThreadVideoModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ThreadVideoModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] ?? 'thread-video',
        attributes: data['attributes'] == null
            ? const ThreadVideoAttributeModel()
            : ThreadVideoAttributeModel.fromMap(maps: data['attributes']));
  }
}

class ThreadVideoAttributeModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// user_id
  /// 关联用户ID
  ///
  final int userID;

  ///
  /// thread_id
  /// 关联主题ID
  ///
  final int threadID;

  ///
  /// status
  /// 关联状态
  ///
  final int status;

  ///
  /// reason
  /// 发布原因
  ///
  final String reason;

  ///
  /// file_name
  /// 文件名称
  final String fileName;

  ///
  /// file_id
  /// 文件ID
  final String fileID;

  ///
  /// media_url
  /// 文件地址
  /// final String mediaUrl;

  ///
  /// cover_url
  /// 封面地址
  final String coverUrl;

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

  const ThreadVideoAttributeModel(
      {this.id = 0,
      this.userID = 0,
      this.threadID = 0,
      this.status = 0,
      this.reason = '',
      this.fileID = '',
      // this.mediaUrl = '',
      this.coverUrl = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.fileName = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ThreadVideoAttributeModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const ThreadVideoAttributeModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ThreadVideoAttributeModel(
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
      status: data['status'] == null
          ? 0
          : data['status'].runtimeType == String
              ? int.tryParse(data['status'])
              : data['status'],
      reason: data['reason'] ?? '',
      fileID: data['file_id'] ?? '',
      //mediaUrl: data['media_url'] ?? '',
      coverUrl: data['cover_url'] ?? '',
      createdAt: data['create_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
    );
  }
}
