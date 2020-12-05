import 'package:flutter/material.dart';

///
/// 要查询的数据
/// 查询接口时，有可选参数，为了代码的可读性，将这些可选参数单独书写在这里
/// todo: 需要在后续的开发中不断增加并完善
class RequestIncludes {
  ///
  /// user
  /// 作者（默认）
  static const String user = "user";

  ///
  /// thread
  /// 主题
  static const String thread = 'thread';

  ///
  /// firstPost
  /// 首贴
  static const String firstPost = 'firstPost';

  ///
  /// threadVideo
  /// 视频
  static const String threadVideo = 'threadVideo';

  ///
  /// lastPostedUser
  /// 查询最后回复的用户
  static const String lastPostedUser = 'lastPostedUser';

  ///
  /// category
  /// 查询分类
  static const String category = 'category';

  ///
  /// deletedUser
  /// 查询删除的用户
  static const String deletedUser = 'deletedUser';

  ///
  /// firstPost.images
  /// 首贴图片
  static const String firstPostImages = 'firstPost.images';

  ///
  /// firstPost.attachments
  /// 首贴附件
  static const String firstPostAttachments = 'firstPost.attachments';

  ///
  /// firstPostLikedUsers
  /// 点赞首贴的用户
  static const String firstPostLikedUsers = 'firstPost.likedUsers';

  ///
  /// lastThreePosts
  /// 最后三条回复
  static const String lastThreePosts = 'lastThreePosts';

  ///
  /// lastThread
  /// 最后发布的主题
  static const String lastThread = 'lastThread';

  ///
  /// lastThread
  /// 最后发布的主题
  static const String lastThreadFirstPost = 'lastThread.firstPost';

  ///
  /// lastThread
  /// 最后发布的主题
  static const String lastThreadFirstPostImages = 'lastThread.firstPost.images';

  ///
  /// lastThreePosts.user
  /// 最后三条回复的用户信息
  static const String lastThreePostsUser = 'lastThreePosts.user';

  ///
  /// lastThreePostsReplyUser
  /// 最后三条回复所回复的用户
  static const String lastThreePostsReplyUser = 'lastThreePosts.replyUser';

  ///
  /// rewardedUsers
  /// 打赏主题的用户
  static const String rewardedUsers = 'rewardedUsers';

  ///
  /// lastDeletedLog
  /// 最后一次被删除的操作日志
  static const String lastDeletedLog = 'lastDeletedLog';

  ///
  /// toUser
  /// 关注用户数据
  static const String toUser = 'toUser';

  ///
  /// toUser.groups
  /// 关注用户数据
  static const String toUserGroups = 'toUser.groups';

  ///
  /// replyUser
  /// 回复的用户
  static const String postReplyUser = 'posts.replyUser';

  ///
  /// posts
  /// 回复
  static const String posts = 'posts';

  ///
  /// postsUser
  /// 回复的用户
  static const String postsUser = 'posts.user';

  ///
  /// postslikedUsers
  /// 点赞的用户
  static const String postslikedUsers = 'posts.likedUsers';

  ///
  /// postsImages
  /// 评论的图片
  static const String postsImages = 'posts.images';

  ///
  /// fromUser
  /// 粉丝用户数据
  static const String fromUser = 'fromUser';

  ///
  /// fromUser.groups
  /// 粉丝用户数据
  static const String fromUserGroups = 'fromUser.groups';

  ///
  /// groups
  /// 指定获取用户组信息
  static const String groups = 'groups';

  ///
  /// fromIncludes
  /// 使用RequestIncludes包含的可用于查询关联信息的数据构造用于请求的 queryParams
  ///
  static String toGetRequestQueries({@required List<String> includes}) {
    if (includes == null || includes.length == 0) {
      return '';
    }
    return includes.map((e) => e).join(',');
  }
}
