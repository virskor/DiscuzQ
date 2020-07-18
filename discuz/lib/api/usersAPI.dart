import 'package:dio/dio.dart';
import 'package:discuzq/utils/request/request.dart';
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
}
