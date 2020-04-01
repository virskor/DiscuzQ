import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';

///
/// 用于复用的请求方法
/// 请求关注或者关注
///
class UserFollowRequest {
  ///
  /// request follow
  /// 如果用户请求取消关注，应该发送delete请求，如果是关注则，直接发送post请求
  /// 关注
  static Future<bool> requestFollow(
      {@required BuildContext context, @required UserModel user}) async {
    Response resp;

    ///
    /// 用于请求的数据
    final dynamic data = {
      "data": {
        "attributes": {
          "to_user_id": user.id,
        }
      }
    };

    final Function closeLoading = DiscuzToast.loading(context: context);

    if (user.follow == 1) {
      /// 取消关注
      /// 取消关注时，会返回204，DIO会默认处理成错误，所以要自己在处理下
      /// 如果后续DZ接口调整，也要直接返回
      try {
        resp = await Request(context: context)
            .delete(url: Urls.follow, data: data);
        closeLoading();
      } catch (e) {
        final DioError err = e;
        if (err.response.statusCode == 204) {
          DiscuzToast.success(context: context, message: '已取消');
          return Future.value(true);
        }
      }
      DiscuzToast.success(context: context, message: '已取消');
      return Future.value(true);
    }

    ///
    /// 请求关注某个用户
    ///
    resp =
        await Request(context: context).postJson(url: Urls.follow, data: data);
    closeLoading();
    if (resp == null) {
      DiscuzToast.failed(context: context, message: '操作失败');
      return Future.value(false);
    }
    DiscuzToast.success(context: context, message: '已关注');
    return Future.value(true);
  }
}
