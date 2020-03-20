import 'dart:convert';
import 'package:flutter/material.dart';

///
/// relationships
///
class RelationshipsModel {
  ///
  /// user
  ///
  ///
  /// {
  ///    "data": {
  ///       "type": "users",
  ///          "id": "3"
  ///       }
  /// }
  ///
  ///
  final dynamic user;

  ///
  /// firstPost
  ///
  ///
  /// {
  ///    "data": {
  ///       "type": "posts",
  ///         "id": "23"
  ///       }
  /// }
  ///
  ///
  final dynamic firstPost;

  ///
  /// threadVideo
  ///
  /// "threadVideo": {
  ///              "data": {
  ///                  "type": "thread-video",
  ///                  "id": "18"
  ///              }
  ///          },
  final dynamic threadVideo;

  ///
  /// posts
  /// post will be an array []
  /// notice: you need use postModel to convert this data
  ///
  final List<dynamic> posts;

  const RelationshipsModel(
      {this.user, this.firstPost, this.threadVideo, this.posts});

  ///
  /// RelationshipsModel
  ///
  static RelationshipsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return RelationshipsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return RelationshipsModel(
        user: data['user'] ?? null,
        firstPost: data['firstPost'] ?? null,
        posts: data['posts'] ?? [],
        threadVideo: data['threadVideo'] ?? null);
  }
}
