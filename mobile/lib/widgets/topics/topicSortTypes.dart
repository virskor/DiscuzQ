import 'package:flutter/material.dart';

enum TopicListSortType {
  ///
  /// 查看次数排序(热度)
  viewCount,

  ///
  /// 帖子数量排序
  threadCount
}

///
/// Map topic sort type
class TopicListSortTypeMapper {
  static const Map<TopicListSortType, String> _types = {
    TopicListSortType.viewCount: '-viewCount',
    TopicListSortType.threadCount: '-threadCount',
  };

  static String map({@required TopicListSortType type}) => _types[type];
}
