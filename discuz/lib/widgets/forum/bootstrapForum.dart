import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

class BootstrapForum {
  final BuildContext context;

  BootstrapForum(this.context);

  /// 获取论坛信息
  /// 单独拆分这个函数的原因是因为防止后续调整页
  /// 因为forum会产生APP bootstrapper 类似的决定性数据
  Future<bool> getForum({bool force = false}) async {
    Response resp;

    final Function closeLoading = DiscuzToast.loading(context: context);

    try {
      final AppState state =
          ScopedStateModel.of<AppState>(context, rebuildOnChange: true);

      /// 减少重复的请求，如果状态已经有数据，直接返回好了
      if(!force && state.forum != null){
        closeLoading();
        return Future.value(true);
      }

      resp = await Request(context: context).getUrl(url: Urls.forum);

      closeLoading();

      if (resp == null) {
        return Future.value(false);
      }

      /// 更新状态
      state.updateForum(resp.data['data']['attributes']);

      /// 返回成功
      return Future.value(true);
    } catch (e) {
      closeLoading();
      return Future.value(false);
    }
  }
}
