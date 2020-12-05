import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/models/qCloudModel.dart';
import 'package:core/models/threadVideoModel.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';

class VideoAPI {
  ///
  /// 出入BuildContext
  final BuildContext context;

  VideoAPI({@required this.context});

  ///
  /// 获取playInfo 视频信息
  /// 根据云点播APPID和视频的fileID来获取视频播放信息
  /// https://playvideo.qcloud.com/getplayinfo/v4/1400331686/5285890802666004536
  ///  https://playvideo.qcloud.com/getplayinfo/v4/ qCloudVODSubAppID file_id
  Future<dynamic> getPlayInfo(
      {@required QCloudModel qcloud, @required ThreadVideoModel video}) async {
    final String url =
        '${Urls.videoPlayInfo}/${qcloud.qCloudVODSubAppID}/${video.attributes.fileID}';

    /// 开始请求
    final Response resp = await Request(context: context).getUrl(url: url);
    if (resp == null) {
      return Future.value(null);
    }

    return Future.value(resp.data);
  }
}
