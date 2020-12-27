import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/models/userGroupModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncludes.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/providers/userProvider.dart';

class UsersAPI {
  ///
  /// BuildContext
  final BuildContext context;

  UsersAPI({@required this.context});

  ///
  /// Modify user's profile
  /// attribute: {signature: 'ceshi'}
  Future<dynamic> updateProfile(CancelToken cancelToken,
      {@required dynamic attributes, @required BuildContext context}) async {
    assert(context != null);
    final int uid = context.read<UserProvider>().user.id;

    final dynamic data = {
      "data": {"type": "users", "id": uid, "attributes": attributes}
    };

    final Response resp = await Request(context: context)
        .patch(cancelToken, url: "${Urls.users}/${uid.toString()}", data: data);

    if (resp == null) {
      return Future.value(null);
    }

    return Future.value(resp.data['data']);
  }

  /// getUser by response
  Future<Response> getUser(CancelToken cancelToken, {@required dynamic uid}) async {
    Response resp = await Request(context: context).getUrl(
      cancelToken,
      url: "${Urls.users}/${uid.toString()}",
    );

    ///
    /// 错误时直接返回
    if (resp == null) {
      return Future.value(null);
    }

    return Future.value(resp);
  }

  ///
  /// 异步的请求用户的信息，以覆盖现有的用户信息
  /// 同时更新用户组信息
  Future<Map<UserModel, UserGroupModel>> getUserDataByID(
      CancelToken cancelToken,
      {@required int uid}) async {
    ///
    /// 关联查询的数据
    ///
    List<String> includes = [RequestIncludes.groups];

    Response resp = await Request(context: context).getUrl(cancelToken,
        url: "${Urls.users}/${uid.toString()}",
        queryParameters: {
          "include": RequestIncludes.toGetRequestQueries(includes: includes),
        });

    ///
    /// 错误时直接返回
    if (resp == null) {
      return Future.value(null);
    }

    final UserModel user = UserModel.fromMap(maps: resp.data['data']);

    /// 无效的用户信息，不参与渲染
    if (user.id == 0) {
      return Future.value(null);
    }

    final List<dynamic> include = resp.data['included'] ?? const [];
    if (include.length == 0) {
      return Future.value(null);
    }

    final UserGroupModel group = UserGroupModel.fromMap(maps: include[0]);

    return Future.value({user: group});
  }

  ///
  /// request follow
  /// 如果用户请求取消关注，应该发送delete请求，如果是关注则，直接发送post请求
  /// 关注
  static Future<bool> requestFollow(CancelToken cancelToken,
      {@required BuildContext context,
      @required UserModel user,
      bool isUnfollow = false}) async {
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

    /// 204 直接return true DIO处理有问题
    if (isUnfollow) {
      try {
        resp = await Request(context: context).delete(cancelToken,
            url: "${Urls.follow}/${user.id.toString()}/1", data: data);
        closeLoading();
      } catch (e) {
        closeLoading();
        return Future.value(true);
      }
      DiscuzToast.toast(context: context, message: '已取消');
      return Future.value(true);
    }

    ///
    /// 请求关注某个用户
    ///
    try {
      resp = await Request(context: context)
          .postJson(cancelToken, url: Urls.follow, data: data);

      closeLoading();

      if (resp == null) {
        DiscuzToast.failed(context: context, message: '操作失败');
        return Future.value(false);
      }

      DiscuzToast.toast(context: context, message: '已关注');

      return Future.value(true);
    } catch (e) {
      closeLoading();
      throw e;
    }
  }
}
