import 'package:flutter/foundation.dart';

import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/threadVideoModel.dart';
import 'package:discuzq/models/userModel.dart';

///
/// transformThreads
/// dynamic 转化为ThreadModels
/// 注意，这个方法不能置于class成员，否则将导致数据无法转化
///
Future<List<ThreadModel>> transformThreads(List<dynamic> data) {
  if (data == null || data.length == 0) {
    return Future.value(const []);
  }
  List<ThreadModel> result =
      data.map<ThreadModel>((t) => ThreadModel.fromMap(maps: t)).toList();
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
  final List<UserModel> reulst = data
      .where((inc) => inc['type'] == 'users')
      .map((p) => UserModel.fromMap(maps: p['attributes']))
      .toList();
  return Future.value(reulst);
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
  get threads => _threads;
  set threads(List<ThreadModel> value) {
    assert(value != null);
    if (_threads == value) return;

    _threads.addAll(value);
  }

  ///
  /// 评论
  ///
  List<PostModel> _posts = [];
  get posts => _posts;
  set posts(List<PostModel> value) {
    assert(value != null);
    if (_posts == value) return;

    _posts.addAll(value);
  }

  ///
  /// 用户
  ///
  List<UserModel> _users = [];
  get users => _users;
  set users(List<UserModel> value) {
    assert(value != null);
    if (_users == value) return;

    _users.addAll(value);
  }

  ///
  /// 附件列表
  ///
  List<AttachmentsModel> _attachments = [];
  get attachments => _attachments;
  set attachments(List<AttachmentsModel> value) {
    assert(value != null);
    if (_attachments == value) return;

    _attachments.addAll(value);
  }

  ///
  /// 视频列表
  ///
  List<ThreadVideoModel> _videos = [];
  get videos => _videos;
  set videos(List<ThreadVideoModel> value) {
    assert(value != null);
    if (_videos == value) return;

    _videos.addAll(value);
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
  Future<void> computeThreadVideos(
      {@required List<dynamic> include}) async {
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
  }
}

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
  /// 但一般情况下，要保持这是个单例的设计
  ///
  /// 所以如果不用了，就一定要clear
  /// 否则，在下次调用的时候数据还在，将直接导致错误的数据渲染
  ///
  factory ThreadsCacher({bool singleton = true}) =>
      _getInstance(singleton: singleton);
  static ThreadsCacher get instance => _getInstance();
  static ThreadsCacher _instance;

  ThreadsCacher._internal() {
    // 初始化单例实例
  }

  static ThreadsCacher _getInstance({bool singleton = true}) {
    if (_instance == null) {
      _instance = ThreadsCacher._internal();
    }

    if (singleton == false) {
      _instance = ThreadsCacher._internal();
    }
    return _instance;
  }
}
