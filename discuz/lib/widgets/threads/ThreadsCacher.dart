import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';

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
  /// 清空数据
  void clear() async {
    _threads.clear();
    _posts.clear();
    _users.clear();
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
  factory ThreadsCacher({bool singleton = true}) => _getInstance(singleton: singleton);
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
