import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/models/forumModel.dart';
import 'package:core/providers/forumProvider.dart';

class ForumAPI {
  final BuildContext context;

  ForumAPI(this.context);

  /// 获取论坛信息
  /// 单独拆分这个函数的原因是因为防止后续调整页
  /// 因为forum会产生APP bootstrapper 类似的决定性数据
  ///
  /// 先从本地缓存取，如果缓存里面有数据，先返回本地缓存的，然后接口获取的就存在本地，下次在使用
  ///
  ///
  Future<bool> getForum({bool force = false}) async {
    try {
      final Response resp =
          await Request(context: context, autoAuthorization: false).getUrl(
              url: Urls.forum, queryParameters: {"filter[tag]": "agreement"});

      if (resp == null) {
        return Future.value(false);
      }

      try {
        final ForumModel forum = ForumModel.fromMap(maps: resp.data['data']);

        /// 更新状态
        context.read<ForumProvider>().updateForum(forum);
      } catch (e) {
        throw e;
      }

      /// 返回成功
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
