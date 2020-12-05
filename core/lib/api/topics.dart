import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/models/topicModel.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';

class TopicsAPI {
  const TopicsAPI({this.context});

  final BuildContext context;

  ///
  /// Get topic single column
  Future<TopicModel> getTopic({int id}) async {
    if (id == null) {
      return Future.value(null);
    }

    Response resp = await Request(context: context)
        .getUrl(url: "${Urls.topics}/${id.toString()}");

    if (resp == null) {
      return Future.value(null);
    }

    return TopicModel.fromMap(maps: resp.data['data']);
  }
}
