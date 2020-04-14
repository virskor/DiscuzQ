import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';

///
/// 帖子相关API请求方法
///
class PostsAPIManager {
  ///
  /// 出入BuildContext
  final BuildContext context;

  PostsAPIManager({@required this.context});

  ///
  /// 删除帖子
  /// 传入要删除的 postID
  /// 删除回复接口[单个]
  ///
  Future<bool> delete({@required int postID}) async {
    final String url = "${Urls.posts}/${postID.toString()}";
    Response _ = await Request(context: context).delete(url: url);

    ///
    /// todo：检查状态码来判定删除成功与否
    /// 现Dio处理Delete put 有问题
    return Future.value(true);
  }
}
