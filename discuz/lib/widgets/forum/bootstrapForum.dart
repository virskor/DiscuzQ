import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/utils/localstorage.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

const String _localForumStorageKey = 'forum';

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
          ScopedStateModel.of<AppState>(context, rebuildOnChange: true);

      final String localForumData =
          await DiscuzLocalStorage.getString(_localForumStorageKey);
      if (!StringHelper.isEmpty(string: localForumData)) {
        state.updateForum(jsonDecode(localForumData));
        closeLoading();
      }

      /// 减少重复的请求，如果状态已经有数据，直接返回好了
      if (!force && state.forum != null) {
        return Future.value(true);
      }

      resp = await Request(context: context).getUrl(url: Urls.forum);
      closeLoading();
      if (resp == null) {
        return Future.value(false);
      }

      /// 更新状态
      state.updateForum(resp.data['data']['attributes']);
      DiscuzLocalStorage.setString(
          _localForumStorageKey, jsonEncode(resp.data['data']['attributes']));

      /// 返回成功
      return Future.value(true);
    } catch (e) {
      closeLoading();
      return Future.value(false);
    }
  }
}
