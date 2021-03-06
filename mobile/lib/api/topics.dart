import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/topicModel.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';

class TopicsApi {
  const TopicsApi({this.context});

  final BuildContext context;

  ///
  /// Get topic single column
  Future<TopicModel> getTopic(CancelToken cancelToken, {int id}) async {
    if (id == null) {
      return Future.value(null);
    }

    Response resp = await Request(context: context)
        .getUrl(cancelToken, url: "${Urls.topics}/${id.toString()}");

    if (resp == null) {
      return Future.value(null);
    }

    return TopicModel.fromMap(maps: resp.data['data']);
  }
}
