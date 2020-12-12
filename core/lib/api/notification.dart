import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';

class NoticficationApi {
  const NoticficationApi({@required this.context});

  final BuildContext context;

  ///
  /// Get topic single column
  Future<bool> deteleNotification(CancelToken cancelToken, {int id}) async {
    if (id == null) {
      return Future.value(null);
    }

    Response _ = await Request(context: context)
        .delete(cancelToken, url: "${Urls.notifications}/${id.toString()}");

    ///
    /// todo：检查状态码来判定删除成功与否
    /// 现Dio处理Delete put 有问题
    return Future.value(true);
  }
}
