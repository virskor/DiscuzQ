import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/utils/request/urls.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/views/reports/reportsDelegate.dart';

class ReportsAPI {
  ///
  /// BuildContext
  final BuildContext context;

  ReportsAPI({@required this.context});

  ///
  /// create Reports
  Future<dynamic> createReports({
    @required ReportType type,
    int threadID = 0,
    postID = 0,
    userID = 0,
    @required String reason,
  }) async {
    /// map current report type
    final int currentReportType = kReportTypes
            .where((element) => element.keys.first == type)
            .first
            .values
            .toList()[0] ??
        0;

    final dynamic data = {
      "data": {
        "type": "reports",
        "attributes": {
          "user_id": userID,
          "thread_id": threadID,
          "post_id": postID,
          "type": currentReportType,
          "reason": reason
        }
      }
    };

    final Response resp =
        await Request(context: context).postJson(url: Urls.reports, data: data);

    if (resp == null) {
      return Future.value(false);
    }

    return Future.value(true);
  }
}
