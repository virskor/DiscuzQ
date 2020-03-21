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
      {this.replied = 0, this.liked = 0, this.rewarded = 0, this.system = 0});

  ///
  /// fromMap
  /// 转换模型
  ///
  static TypeUnreadNotificationsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const TypeUnreadNotificationsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 要注意，有的时候 接口没有消息的时候会返回 [],数组，这时和Map<String, dynamic> 不一样，继续转换，会导致错误！
    /// 
    if(data.runtimeType != dynamic && data.length == 0){
      return const TypeUnreadNotificationsModel();
    }


    return TypeUnreadNotificationsModel(
      replied: data['replied'] == null
          ? 0
          : data['replied'].runtimeType == String
              ? int.tryParse(data['replied'])
              : data['replied'],
      liked: data['liked'] == null
          ? 0
          : data['liked'].runtimeType == String
              ? int.tryParse(data['liked'])
              : data['liked'],
      rewarded: data['rewarded'] == null
          ? 0
          : data['rewarded'].runtimeType == String
              ? int.tryParse(data['rewarded'])
              : data['rewarded'],
      system: data['system'] == null
          ? 0
          : data['system'].runtimeType == String
              ? int.tryParse(data['system'])
              : data['system'],
    );
  }
}
