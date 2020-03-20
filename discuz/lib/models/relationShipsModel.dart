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
  /// lastThreePosts
  /// 最近3条回复
  final List<dynamic> lastThreePosts;

  ///
  /// lastThreePosts
  /// 打赏的用户
  final List<dynamic> rewardedUsers;

  ///
  /// replyUser
  /// 回复的用户
  final dynamic replyUser;

  const RelationshipsModel(
      {this.user,
      this.firstPost,
      this.threadVideo,
      this.replyUser,
      this.rewardedUsers = const [],
      this.lastThreePosts = const []});

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
        replyUser: data['replyUser'] ?? null,
        lastThreePosts: data['lastThreePosts'] == null
            ? []
            : data['lastThreePosts']['data'],
        rewardedUsers:
            data['rewardedUsers'] == null ? [] : data['rewardedUsers']['data'],
        threadVideo: data['threadVideo'] ?? null);
  }
}
