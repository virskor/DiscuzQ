import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

class BlackListAPI {
  const BlackListAPI({this.context});

  final BuildContext context;

  ///
  /// Add black list by user's ID
  Future<bool> add({@required int uid}) async {
    final Function close = DiscuzToast.loading();

    final String url = '${Urls.users}/${uid.toString()}/deny';

    try {
      Response resp = await Request(context: context).postJson(url: url);

      close();

      if (resp != null) {
        return Future.value(true);
      }

      return Future.value(false);
    } catch (e) {
      close();
      throw e;
    }
  }

  ///
  /// Add black list by user's ID
  Future<bool> delete({@required int uid}) async {
    final Function close = DiscuzToast.loading();

    final String url = '${Urls.users}/${uid.toString()}/deny';

    try {
      Response resp = await Request(context: context).delete(url: url);

      close();

      if (resp != null) {
        return Future.value(true);
      }

      return Future.value(false);
    } catch (e) {
      close();
      throw e;
    }
  }


}
