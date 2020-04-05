import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/models/forumModel.dart';

class BootstrapForum {
  final BuildContext context;

  BootstrapForum(this.context);

  /// 获取论坛信息
  /// 单独拆分这个函数的原因是因为防止后续调整页
  /// 因为forum会产生APP bootstrapper 类似的决定性数据
  ///
  /// 先从本地缓存取，如果缓存里面有数据，先返回本地缓存的，然后接口获取的就存在本地，下次在使用
  ///
  ///
  Future<bool> getForum({bool force = false}) async {
    Response resp;

    final Function closeLoading = DiscuzToast.loading(context: context);

    try {
      final AppState state =
          ScopedStateModel.of<AppState>(context, rebuildOnChange: false);

      resp = await Request(context: context, autoAuthorization: false).getUrl(url: Urls.forum);
      closeLoading();
      if (resp == null) {
        return Future.value(false);
      }

      try {
        final ForumModel forum = ForumModel.fromMap(maps: resp.data['data']);

        /// 更新状态
        state.updateForum(forum);
      } catch (e) {
        print(e);
      }

      /// 返回成功
      return Future.value(true);
    } catch (e) {
      closeLoading();
      return Future.value(false);
    }
  }
}
