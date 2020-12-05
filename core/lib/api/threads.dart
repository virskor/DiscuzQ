import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/editor/discuzEditorRequestResult.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/models/userModel.dart';

///
/// 主题相关的API
class ThreadsAPI {
  ///
  /// 出入BuildContext
  final BuildContext context;

  ThreadsAPI({@required this.context});

  ///
  /// 获取帖子详情
  ///
  Future<ThreadModel> getDetailByID({@required int threadID}) async {
    final Function close = DiscuzToast.loading(context: context);

    try {
      final String uri = "${Urls.threads}/${threadID.toString()}";
      Response resp = await Request(context: context).getUrl(url: uri);

      ///
      /// close loading animations
      close();

      if (resp == null) {
        return null;
      }

      return ThreadModel.fromMap(maps: resp.data['data']);
    } catch (e) {
      close();
      throw e;
    }
  }

  ///
  /// 删除主题
  /// 仅判断删除结果
  ///
  Future<bool> delete({@required ThreadModel thread}) async {
    final Function close = DiscuzToast.loading(context: context);

    try {
      final dynamic data = {
        "data": {
          "type": "threads",
          "attributes": {"isDeleted": true}
        },
        "relationships": {"category": thread.relationships.category}
      };

      /// 开始请求
      Response resp = await Request(context: context)
          .patch(url: '${Urls.threads}/${thread.id.toString()}', data: data);
      close();

      if (resp == null) {
        return Future.value(false);
      }

      DiscuzToast.toast(context: context, message: '删除成功');

      return Future.value(true);
    } catch (e) {
      close();
      throw e;
    }
  }

  ///
  /// 发布主题
  ///
  Future<DiscuzEditorRequestResult> create({@required dynamic data}) async {
    final Function close = DiscuzToast.loading(context: context);

    try {
      /// 开始请求
      Response resp = await Request(context: context)
          .postJson(url: Urls.threads, data: data);

      close();

      /// 数据提交后，如果成功，会获取到一个Post模型数据
      /// 此外，还有用户信息，要将这些数据push到threadCacher，这样UI便会渲染出刚才我发送的数据
      if (resp == null) {
        return Future.value(null);
      }

      ///
      /// 将输入加入threadCacher，之后再返回成功的结果，这样UI便可以自动渲染刚才用户发布的信息
      final ThreadModel thread = ThreadModel.fromMap(maps: resp.data['data']);

      final List<dynamic> included = resp.data['included'];

      final List<dynamic> users =
          included.where((it) => it['type'] == 'users').toList();
      final List<dynamic> posts =
          included.where((it) => it['type'] == 'posts').toList();

      return DiscuzEditorRequestResult(
          posts: posts.map((p) => PostModel.fromMap(maps: p)).toList(),
          users: users.map((u) => UserModel.fromMap(maps: u)).toList(),
          thread: thread);
    } catch (e) {
      print(e);
      close();
      return Future.value(null);
    }
  }
}
