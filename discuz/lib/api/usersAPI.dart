import 'package:dio/dio.dart';
import 'package:discuzq/models/userGroupModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncludes.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/states/appState.dart';

class UsersAPI {
  ///
  /// BuildContext
  final BuildContext context;

  UsersAPI({@required this.context});

  ///
  /// Modify user's profile
  /// attribute: {signature: 'ceshi'}
  Future<dynamic> updateProfile(
      {@required dynamic attributes, @required AppState state}) async {
    assert(state != null);
    final int uid = state.user.id;

    final dynamic data = {
      "data": {"type": "users", "id": uid, "attributes": attributes}
    };

    final Response resp = await Request(context: context)
        .patch(url: "${Urls.users}/${uid.toString()}", data: data);

    if (resp == null) {
      return Future.value(null);
    }

    return Future.value(resp.data['data']);
  }

  ///
  /// 异步的请求用户的信息，以覆盖现有的用户信息
  /// 同时更新用户组信息
  Future<Map<UserModel, UserGroupModel>> getUserDataByID({@required int uid}) async {
    ///
    /// 关联查询的数据
    ///
    List<String> includes = [RequestIncludes.groups];

    Response resp = await Request(context: context)
        .getUrl(url: "${Urls.users}/${uid.toString()}", queryParameters: {
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
}
