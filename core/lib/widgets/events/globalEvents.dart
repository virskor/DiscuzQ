import 'package:core/models/postModel.dart';
import 'package:core/models/userModel.dart';
import 'package:event_bus/event_bus.dart';

/// 在页面中请求切换tab
EventBus eventBus = EventBus();

/// 用户手动点击更新事件
class WantUpgradeAppVersion {
  WantUpgradeAppVersion();
}

/// 发布评论后将发布的评论加入评论列表
class WantAddReplyToThreadCache{
  WantAddReplyToThreadCache({this.user, this.post});

  List<UserModel> user;

  List<PostModel> post;
}