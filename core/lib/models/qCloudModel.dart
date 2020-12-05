import 'dart:convert';
import 'package:flutter/material.dart';

class QCloudModel {
  ///
  /// 腾讯云应用ID
  /// qcloud_app_id
  final String qCloudAppID;

  ///
  /// 是否 启用腾讯云验证码(天御)
  /// qcloud_captcha
  final bool qCloudCaptcha;

  ///
  /// 天御验证码APPID
  /// qcloud_captcha_app_id
  final String qCloudCaptchaAppID;

  ///
  /// 云api开关
  /// qcloud_close
  final bool qCloudClose;

  ///
  /// 对象存储
  /// qcloud_cos
  final bool qCloudCOS;

  ///
  /// qcloud_faceid
  final bool qCloudFaceID;

  ///
  /// 腾讯云短信开启
  /// qcloud_sms
  final bool qCloudSMS;

  ///
  /// 腾云点播
  /// qcloud_vod
  final bool qCloudVOD;

  ///
  /// 腾讯云点播视频拓展名
  /// qcloud_vod_ext
  final String qCloudVODExt;

  ///
  /// 云点播视频大小
  /// qcloud_vod_size
  /// 默认200
  final int qCloudVODSize;

  ///
  /// 云点播APPid 用于视频信息查询
  /// qcloud_vod_sub_app_id
  final String qCloudVODSubAppID;

  const QCloudModel(
      {this.qCloudAppID = '',
      this.qCloudCaptcha = false,
      this.qCloudClose = false,
      this.qCloudCOS = false,
      this.qCloudFaceID = false,
      this.qCloudSMS = false,
      this.qCloudVOD = false,
      this.qCloudVODExt = '',
      this.qCloudVODSubAppID = '',
      this.qCloudVODSize = 200,
      this.qCloudCaptchaAppID = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static QCloudModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const QCloudModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return QCloudModel(
      qCloudAppID: data['qcloud_app_id'] ?? '',
      qCloudCaptcha: data['qcloud_captcha'] ?? false,
      qCloudCaptchaAppID: data['qcloud_captcha_app_id'] ?? '',
      qCloudClose: data['qcloud_close'] ?? false,
      qCloudCOS: data['qcloud_cos'] ?? false,
      qCloudFaceID: data['qcloud_faceid'] ?? false,
      qCloudSMS: data['qcloud_sms'] ?? false,
      qCloudVOD: data['qcloud_vod'] ?? false,
      qCloudVODExt: data['qcloud_vod_ext'] ?? '',
      qCloudVODSubAppID: data['qcloud_vod_sub_app_id'] ?? '',
      qCloudVODSize: data['qcloud_vod_size'] == null
          ? 0
          : data['qcloud_vod_size'].runtimeType == String
              ? int.tryParse(data['qcloud_vod_size'])
              : data['qcloud_vod_size'],
    );
  }
}
