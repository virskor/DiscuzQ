import 'dart:convert';
import 'package:flutter/material.dart';

///
/// 天御验证码数据模型
///
class CaptchaModel {
  ///
  /// appID
  ///
  final int appID;

  ///
  /// ticket 票据
  ///
  final String ticket;

  ///
  /// ret
  final int ret;

  ///
  /// randstr
  ///
  final String randSTR;

  const CaptchaModel(
      {this.appID = 0, this.ticket = '', this.ret = 0, this.randSTR = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static CaptchaModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const CaptchaModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return CaptchaModel(
        appID: data['appid'] == null
            ? 0
            : data['appid'].runtimeType == String
                ? int.tryParse(data['appid'])
                : data['appid'],
        ret: data['ret'] == null
            ? 0
            : data['ret'].runtimeType == String
                ? int.tryParse(data['ret'])
                : data['ret'],
        randSTR: data['randstr'] ?? '',
        ticket: data['ticket'] ?? '');
  }
}
