import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzText.dart';

class SearchResultTabs extends StatefulWidget {
  ///
  /// keyword
  /// 用于呈现搜索结果的关键字
  final String keyword;

  const SearchResultTabs({this.keyword = ''});

  @override
  _SearchResultTabsState createState() => _SearchResultTabsState();
}

class _SearchResultTabsState extends State<SearchResultTabs> {
  @override
  void didUpdateWidget(SearchResultTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    ///
    /// 如果 filter 发生变化，和上次filter不同那么就是发生变化
    /// 这时候刷新请求变化
    if (oldWidget.keyword != widget.keyword) {
      Future.delayed(Duration(milliseconds: 450))
          .then((_) async => await _requestData(pageNumber: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: DiscuzText(widget.keyword));
  }


  ///
  /// 请求数据
  /// 
  Future<void> _requestData({int pageNumber}) {}
}
