import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

class BootstrapForum {
  final BuildContext context;

  BootstrapForum(this.context);

  /// 获取论坛信息
  /// 单独拆分这个函数的原因是因为防止后续调整页
  /// 因为forum会产生APP bootstrapper 类似的决定性数据
  Future<bool> getForum() async {
    Response resp;

    final Function closeLoading = DiscuzToast.loading(context: context);

    try {
      final AppModel model =
          ScopedModel.of<AppModel>(context, rebuildOnChange: true);
      resp = await Request(context: context).getUrl(url: Urls.forum);

      closeLoading();

      if (resp == null) {
        return Future.value(false);
      }

      /// 更新状态
      model.updateForum(resp.data['data']['attributes']);

      /// 返回成功
      return Future.value(true);
    } catch (e) {
      print(e);
      closeLoading();
      return Future.value(false);
    }
  }
}
