import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/widgets/editor/discuzEditorRequestResult.dart';
import 'package:core/widgets/common/discuzToast.dart';

///
/// 帖子相关API请求方法
/// 由于该API会在不同组件复用，所以单独抽出
///
class PostsAPI {
  ///
  /// 出入BuildContext
  final BuildContext context;

  PostsAPI({@required this.context});

  ///
  /// 创建回复
  /// data 用于提交到接口的数据，数据将被用来创建回复
  ///
  Future<DiscuzEditorRequestResult> create({@required dynamic data}) async {
    final Function close = DiscuzToast.loading(context: context);

    try {
      /// 开始请求
      Response resp =
          await Request(context: context).postJson(url: Urls.posts, data: data);

      close();

      /// 数据提交后，如果成功，会获取到一个Post模型数据
      /// 此外，还有用户信息，要将这些数据push到threadCacher，这样UI便会渲染出刚才我发送的数据
      if (resp == null) {
        return Future.value(null);
      }

      ///
      /// 将输入加入threadCacher，之后再返回成功的结果，这样UI便可以自动渲染刚才用户发布的信息
      final PostModel post = PostModel.fromMap(maps: resp.data['data']);

      /// 匹配用户
      List<UserModel> users = [];
      final List<dynamic> included = resp.data['included'];
      if (included != null && included.length > 0) {
        included.forEach((it) {
          ///
          /// 仅取用户信息
          if (it['type'] == 'users') {
            users.add(UserModel.fromMap(maps: it));
          }
        });
      }

      /// 好了，将数据加入threadCacher
      return Future.value(DiscuzEditorRequestResult(
        posts: [post],
        users: users,
      ));
    } catch (e) {
      close();
      throw e;
    }
  }

  ///
  /// 删除帖子
  /// 传入要删除的 postID
  /// 删除回复接口[单个]
  ///
  Future<bool> delete({@required int postID}) async {
    final String url = "${Urls.posts}/${postID.toString()}";
    Response _ = await Request(context: context).delete(url: url);

    ///
    /// todo：检查状态码来判定删除成功与否
    /// 现Dio处理Delete put 有问题
    return Future.value(true);
  }
}
