import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';

class AttachmentsApi {
  const AttachmentsApi({this.context});

  final BuildContext context;

  ///
  /// remove single file column
  Future<void> remove(CancelToken cancelToken, {int id}) async {
    if (id == null) {
      return Future.value(null);
    }

    await Request(context: context)
        .delete(cancelToken, url: "${Urls.attachments}/${id.toString()}");

    return Future.value(null);
  }
}
