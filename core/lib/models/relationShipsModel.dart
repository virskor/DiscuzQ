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
  /// lastThreePosts
  /// 打赏的用户
  final List<dynamic> likedUsers;

  ///
  /// replyUser
  /// 回复的用户
  final dynamic replyUser;

  ///
  /// images
  /// 帖子关联的图片
  final List<dynamic> images;

  ///
  /// toUser
  /// 关注的人
  final dynamic toUser;

  ///
  /// fromUser
  /// 关注我的人
  final dynamic fromUser;

  ///
  /// category
  /// 关联的分类
  final dynamic category;

  ///
  /// groups
  /// 用户组
  /// [
  ///  { "type":"groups", "id":"1" }
  /// ]
  final List<dynamic> groups;

  const RelationshipsModel(
      {this.user,
      this.firstPost,
      this.threadVideo,
      this.replyUser,
      this.toUser,
      this.fromUser,
      this.category,
      this.images = const [],
      this.groups = const [],
      this.likedUsers = const [],
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
      return const RelationshipsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return RelationshipsModel(
        user: data['user'] ?? null,
        toUser: data['toUser'] ?? null,
        fromUser: data['fromUser'] ?? null,
        category: data['category'] ?? null,
        firstPost: data['firstPost'] ?? null,
        replyUser: data['replyUser'] ?? null,
        groups:
            data['groups'] == null ? [] : data['groups']['data'] ?? [],
        likedUsers:
            data['likedUsers'] == null ? [] : data['likedUsers']['data'] ?? [],
        images: data['images'] == null ? [] : data['images']['data'] ?? [],
        lastThreePosts: data['lastThreePosts'] == null
            ? []
            : data['lastThreePosts']['data'] ?? [],
        rewardedUsers: data['rewardedUsers'] == null
            ? []
            : data['rewardedUsers']['data'] ?? [],
        threadVideo: data['threadVideo'] ?? null);
  }
}
