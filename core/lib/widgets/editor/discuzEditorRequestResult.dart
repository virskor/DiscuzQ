import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/models/userModel.dart';

/// 这个是一个封装用于用户提交评论，创建主题的类
/// 这个类实际上什么都不会做，不会包含任何的处理逻辑，仅包含用户提交后得到的接口反馈结果
/// 数据只读
class DiscuzEditorRequestResult {
  ///
  /// 所创建的评论信息
  final List<PostModel> posts;

  ///
  /// 包含的用户信息数据
  final List<UserModel> users;

  ///
  /// 包含的主题信息
  ///
  final ThreadModel thread;

  const DiscuzEditorRequestResult(
      {this.posts, this.users = const [], this.thread});
}
