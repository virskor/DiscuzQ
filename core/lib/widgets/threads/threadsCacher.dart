import 'package:core/models/topicModel.dart';
import 'package:flutter/foundation.dart';

import 'package:core/models/attachmentsModel.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/models/threadVideoModel.dart';
import 'package:core/models/userModel.dart';

///
/// 一个用与缓存主题信息的类
/// 一个页面在加载完所有主题数据，包括评论，用户等，都会被分类存储到这里
/// 在这里提取要用于渲染的主题列表和其他信息。
/// 当页面销毁的时候，直接将 ThreadsCacher 销毁，完成内存的释放，
/// ThreadsCacher 设计的目的就是为了托管所有用来渲染主题列表相关页面的数据
/// 这个类将作为单例被调用，多个页面只能共享一个 ThreadsCacher
/// dispose将清空所有的数据
///
/// ThreadsCacher 包含的getter， 他们可以获取这些数据，
/// 但是更新这些数据只能由统一的方式进行，以便于去除重复的数据
class ThreadsCacher extends _ThreadBaseCacher {
  ///
  /// 注意 ThreadsCacher 是一个单例，但当singleton传入为false时，则不会是一个单例，
  /// 这是为了多个Stack调用时出现数据重复
  ///
  /// 现在由于一些优化，一般情况下不需要保证是单例了，因为我们有完整的内存释放和对Dart多线程独立内存的使用
  ///
  /// 所以如果不用了，就一定要clear
  /// 否则，在下次调用的时候数据还在，将直接导致错误的数据渲染
  ///
  factory ThreadsCacher({bool singleton = false}) =>
      _getInstance(singleton: singleton);
  static ThreadsCacher get instance => _getInstance();
  static ThreadsCacher _instance;

  ThreadsCacher._internal() {
    // 初始化单例实例
  }

  static ThreadsCacher _getInstance({bool singleton = false}) {
    if (_instance == null) {
      _instance = ThreadsCacher._internal();
    }

    if (singleton == false) {
      _instance = ThreadsCacher._internal();
    }
    return _instance;
  }
}

///
/// transformPosts
/// dynamic 转化为PostModels
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<PostModel>> transformPosts(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<PostModel> reulst = data
      .where((inc) => inc['type'] == 'posts')
      .map((p) => PostModel.fromMap(maps: p))
      .toList();
  return Future.value(reulst);
}

class _ThreadBaseCacher {
  ///
  /// 话题
  ///
  List<ThreadModel> _threads = [];
  List<ThreadModel> get threads => _threads;

  /// 为什么不支持更新数据而只支持增加数据?
  /// 答：APP不卡不开心吗
  set threads(List<ThreadModel> value) {
    assert(value != null);
    if (_threads == value) return;

    _threads.addAll(value);
  }

  ///
  /// 移除主题
  void removeThreadByID({@required int threadID}) {
    _threads = _threads.where((it) => it.id != threadID).toList();
  }

  ///
  /// 评论
  ///
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  ///
  /// 注意，更新posts只会添加而不是传入数据，更新成你传入的那样
  /// 为什么不支持更新数据而只支持增加数据?
  /// 答：本来就不该在这里更新数据，这里只能添加，查看compute...相关方法
  /// todo: 不要让重复的数据被添加进来
  set posts(List<PostModel> value) {
    assert(value != null);
    if (_posts == value) return;

    _posts.addAll(value);
  }

  ///
  /// 移除评论数据
  /// 通常要在请求接口删除评论成功后再调用这个方法，setState后便可直接重构UI
  void removePostByID({@required int postID}) {
    _posts = _posts.where((it) => it.id != postID).toList();
  }

  ///
  /// 用户
  ///
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  /// 为什么不支持更新数据而只支持增加数据?
  /// 答：本来就不该在这里更新数据，这里只能添加，查看compute...相关方法
  /// todo: 不要让重复的数据被添加进来
  set users(List<UserModel> value) {
    assert(value != null);
    if (_users == value) return;

    _users.addAll(value);
  }

  ///
  /// 附件列表
  ///
  List<AttachmentsModel> _attachments = [];
  List<AttachmentsModel> get attachments => _attachments;

  /// 为什么不支持更新数据而只支持增加数据?
  /// 答：本来就不该在这里更新数据，这里只能添加，查看compute...相关方法
  /// todo: 不要让重复的数据被添加进来
  set attachments(List<AttachmentsModel> value) {
    assert(value != null);
    if (_attachments == value) return;

    _attachments.addAll(value);
  }

  ///
  /// 视频列表
  ///
  List<ThreadVideoModel> _videos = [];
  List<ThreadVideoModel> get videos => _videos;

  /// 为什么不支持更新数据而只支持增加数据?
  /// 答：本来就不该在这里更新数据，这里只能添加，查看compute...相关方法
  /// todo: 不要让重复的数据被添加进来
  set videos(List<ThreadVideoModel> value) {
    assert(value != null);
    if (_videos == value) return;

    _videos.addAll(value);
  }

  ///
  /// 话题列表
  ///
  List<TopicModel> _topics = [];
  List<TopicModel> get topics => _topics;

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// threads需为数组
  Future<void> computeTopics({@required List<dynamic> topics}) async {
    List<TopicModel> topicsResult = await compute(transformTopics, topics);
    _topics.addAll(topicsResult);
  }

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// threads需为数组
  Future<void> computeThreads({@required List<dynamic> threads}) async {
    List<ThreadModel> threadsResult = await compute(transformThreads, threads);
    _threads.addAll(threadsResult);
  }

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// users需为数组
  Future<void> computeUsers({@required List<dynamic> include}) async {
    List<UserModel> usersResult = await compute(transformUsers, include);
    _users.addAll(usersResult);
  }

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// posts需为数组
  Future<void> computePosts({@required List<dynamic> include}) async {
    List<PostModel> postsResult = await compute(transformPosts, include);
    _posts.addAll(postsResult);
  }

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// posts需为数组
  Future<void> computeAttachements({@required List<dynamic> include}) async {
    List<AttachmentsModel> attachmentResult =
        await compute(transformAttachments, include);
    _attachments.addAll(attachmentResult);
  }

  ///
  /// 使用隔离的内存，自动运算模型转换
  /// 将响应中的模型数据自动转换为UI模型
  /// posts需为数组
  Future<void> computeThreadVideos({@required List<dynamic> include}) async {
    List<ThreadVideoModel> videosResult =
        await compute(transformThreadVideos, include);
    _videos.addAll(videosResult);
  }

  ///
  /// 清空数据
  void clear() async {
    _threads.clear();
    _posts.clear();
    _users.clear();
    _videos.clear();
    _attachments.clear();
    _topics.clear();
  }
}

///
/// transformThreads
/// dynamic 转化为ThreadModels
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<ThreadModel>> transformThreads(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<ThreadModel> result = data
      .where((inc) => inc['type'] == 'threads')
      .map((u) => ThreadModel.fromMap(maps: u))
      .toList();
  return Future.value(result);
}

///
/// transformTopics
/// dynamic 转化为Topicmodel
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<TopicModel>> transformTopics(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<TopicModel> result = data
      .where((inc) => inc['type'] == 'topics')
      .map((u) => TopicModel.fromMap(maps: u))
      .toList();
  return Future.value(result);
}

///
/// transformUsers
/// dynamic 转化为UserModels
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<UserModel>> transformUsers(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<UserModel> result = data
      .where((inc) => inc['type'] == 'users')
      .map((u) => UserModel.fromMap(maps: u))
      .toList();
  return Future.value(result);
}

///
/// transformAttachments
/// dynamic 转化为 AttachmentsModel
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<AttachmentsModel>> transformAttachments(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<AttachmentsModel> reulst = data
      .where((inc) => inc['type'] == 'attachments')
      .map((p) => AttachmentsModel.fromMap(maps: p))
      .toList();
  return Future.value(reulst);
}

///
/// transformThreadVideoModel
/// dynamic 转化为 ThreadVideoModel
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<ThreadVideoModel>> transformThreadVideos(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  final List<ThreadVideoModel> reulst = data
      .where((inc) => inc['type'] == 'thread-video')
      .map((p) => ThreadVideoModel.fromMap(maps: p))
      .toList();
  return Future.value(reulst);
}
