import 'dart:convert';

import 'package:flutter/material.dart';

class TopicModel {
  const TopicModel(
      {this.id = 0,
      this.type = 'topics',
      this.relationships = const TopicRelationshipModel(),
      this.attributes = const TopicAttributeModel()});

  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final String type;

  /// 关联的数据
  final TopicRelationshipModel relationships;

  ///
  /// 关联的数据
  final TopicAttributeModel attributes;

  ///
  /// fromMap
  /// 转换模型
  ///
  static TopicModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const TopicModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return TopicModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] ?? 'thread-video',
        relationships: data['relationships'] == null
            ? const TopicRelationshipModel()
            : TopicRelationshipModel.formMap(maps: data['relationships']),
        attributes: data['attributes'] == null
            ? const TopicAttributeModel()
            : TopicAttributeModel.fromMap(maps: data['attributes']));
  }
}

class TopicAttributeModel {
  const TopicAttributeModel(
      {this.content = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.viewCount = 0,
      this.userID = 0,
      this.threadCount = 0});

  /// content
  /// 话题内容
  final String content;

  /// thread_count
  /// 关联的话题数量
  final int threadCount;

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

  /// view_count
  /// 查看次数，热度
  final int viewCount;

  /// user_id
  /// 创建人ID
  final int userID;

  ///
  /// fromMap
  /// 转换模型
  ///
  static TopicAttributeModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const TopicAttributeModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return TopicAttributeModel(
      userID: data['user_id'] == null
          ? 0
          : data['user_id'].runtimeType == String
              ? int.tryParse(data['user_id'])
              : data['user_id'],
      viewCount: data['view_count'] == null
          ? 0
          : data['view_count'].runtimeType == String
              ? int.tryParse(data['view_count'])
              : data['view_count'],
      threadCount: data['thread_count'] == null
          ? 0
          : data['thread_count'].runtimeType == String
              ? int.tryParse(data['thread_count'])
              : data['thread_count'],
      content: data['content'] ?? '',
      createdAt: data['create_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
    );
  }
}

class TopicRelationshipModel {
  const TopicRelationshipModel({this.lastThread, this.user});

  final dynamic lastThread;

  final dynamic user;

  

  static TopicRelationshipModel formMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const TopicRelationshipModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }
    
    if(maps['user'] == null || maps['lastThread'] == null){
      return const TopicRelationshipModel();
    }
    return TopicRelationshipModel(
        lastThread: maps['lastThread']['data'][0] ?? null, user: maps['user']['data'] ?? null);
  }
}
