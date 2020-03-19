import 'dart:convert';
import 'package:flutter/material.dart';

class ThreadModel {
  ///
  /// id
  ///
  final String id;

  ///
  /// 主题类型
  ///
  final String type;

  ///
  /// 主题信息
  ///
  final ThreadAttributesModel attributes;

  ///
  /// relationships
  /// 关联数据
  final ThreadAttributesRelationshipsModel relationships;

  /// 主题模型
  const ThreadModel({this.id, this.type, this.attributes, this.relationships});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ThreadModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return ThreadModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return ThreadModel(
        id: data['id'] ?? 0,
        type: data['type'],
        relationships: data['attributes'] == null
            ? ThreadAttributesRelationshipsModel()
            : ThreadAttributesRelationshipsModel.fromMap(
                maps: data['relationships']),
        attributes: data['attributes'] == null
            ? ThreadAttributesModel()
            : ThreadAttributesModel.fromMap(maps: data['attributes']));
  }
}

class ThreadAttributesModel {
  ///
  /// type
  /// 文章类型(0普通 1长文 2视频)
  final int type;

  ///
  /// title
  /// 长文主题	标题
  final String title;

  ///
  /// price
  /// 查看价格
  final String price;

  ///
  /// viewCount
  /// 查看次数
  final int viewCount;

  ///
  /// postCount
  /// 帖子数
  final int postCount;

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
  /// deletedAt
  /// 删除时间(在回收站时显示)
  final String deletedAt;

  ///
  /// isApproved
  /// 是否合法(审核)
  final bool isApproved;

  ///
  /// isSticky
  ///是否顶置
  final bool isSticky;

  ///
  /// isEssence
  /// 是否是精华
  final bool isEssence;

  ///
  /// isFavorite
  /// 是否已经被我收藏
  final bool isFavorite;

  ///
  /// paid
  /// 是否已经支付
  final bool paid;

  ///
  /// canViewPosts
  /// 是否有权查看详情
  final bool canViewPosts;

  ///
  /// canReply
  /// 是否可以恢复
  final bool canReply;

  ///
  /// canApprove
  /// 是否有权审核
  final bool canApprove;

  ///
  /// canSticky
  /// 是否有权限顶置
  final bool canSticky;

  ///
  /// canEssence
  /// 是否有权限加精华
  final bool canEssence;

  ///
  /// canDelete
  /// 是否有权永久删除
  final bool canDelete;

  ///
  /// canHide
  /// 是否有权放入回收站
  final bool canHide;

  ///
  /// canFavorite
  /// 是否有权收藏
  final bool canFavorite;

  const ThreadAttributesModel(
      {this.type = 0,
      this.title = '',
      this.price = '0.00',
      this.createdAt = '',
      this.updatedAt = '',
      this.deletedAt = '',
      this.postCount = 0,
      this.isApproved = false,
      this.isSticky = false,
      this.canFavorite = false,
      this.canHide = false,
      this.canEssence = false,
      this.canApprove = false,
      this.canSticky = false,
      this.paid = false,
      this.isFavorite = false,
      this.isEssence = false,
      this.canReply = false,
      this.canViewPosts = false,
      this.canDelete = false,
      this.viewCount = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ThreadAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return ThreadAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ThreadAttributesModel(
        type: data['type'] ?? 0,
        title: data['title'] ?? '',
        price: data['price'] ?? '0.00',
        createdAt: data['createdAt'] ?? '',
        updatedAt: data['updatedAt'] ?? '',
        deletedAt: data['deletedAt'] ?? '',
        postCount: data['postCount'] ?? 0,
        isApproved: data['isApproved'] ?? false,
        isSticky: data['isSticky'] ?? false,
        canFavorite: data['canFavorite'] ?? false,
        canHide: data['canHide'] ?? false,
        canEssence: data['canEssence'] ?? false,
        canApprove: data['canApprove'] ?? false,
        canSticky: data['canSticky'] ?? false,
        paid: data['paid'] ?? false,
        isFavorite: data['isFavorite'] ?? false,
        isEssence: data['isEssence'] ?? false,
        canReply: data['canReply'] ?? false,
        canViewPosts: data['canViewPosts'] ?? false,
        canDelete: data['canDelete'] ?? false,
        viewCount: data['viewCount'] ?? false);
  }
}

///
/// relationships
///
class ThreadAttributesRelationshipsModel {
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

  const ThreadAttributesRelationshipsModel(
      {this.user, this.firstPost, this.threadVideo, this.posts});

  ///
  /// ThreadAttributesRelationshipsModel
  ///
  static ThreadAttributesRelationshipsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return ThreadAttributesRelationshipsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ThreadAttributesRelationshipsModel(
        user: data['user'] ?? null,
        firstPost: data['firstPost'] ?? null,
        posts: data['posts'] ?? [],
        threadVideo: data['threadVideo'] ?? null);
  }
}
