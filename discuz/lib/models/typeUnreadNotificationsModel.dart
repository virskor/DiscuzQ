import 'dart:convert';
import 'package:flutter/material.dart';

class TypeUnreadNotificationsModel {
  ///
  /// replied
  /// 未读回复消息数
  ///
  final int replied;

  ///
  /// liked
  /// 未读点赞消息数
  ///
  final int liked;

  ///
  /// rewarded
  /// 未读打赏消息数
  ///
  final int rewarded;

  ///
  /// system
  /// 未读系统消息
  ///
  final int system;

  ///
  /// 未读消息数量模型
  ///
  const TypeUnreadNotificationsModel(
      {this.replied = 0, this.liked = 0, this.rewarded = 0, this.system});

  ///
  /// fromMap
  /// 转换模型
  /// 
  static TypeUnreadNotificationsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return TypeUnreadNotificationsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return TypeUnreadNotificationsModel(
        replied: data['replied'] ?? 0,
        liked: data['liked'] ?? 0,
        rewarded: data['rewarded'] ?? 0,
        system: data['system'] ?? 0);
  }
}
