import 'package:flutter/material.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/topics/topicsList.dart';
import 'package:discuzq/widgets/topics/topicListBar.dart';
import 'package:discuzq/widgets/topics/topicSortTypes.dart';

enum DiscuzAppSearchType {
  ///
  /// Search for Thread
  thread,

  ///
  /// Search for User
  user,

  ///
  /// Search for topics
  topic
}

class AppSearchDelegate extends StatefulWidget {
  const AppSearchDelegate();
  @override
  _AppSearchDelegateState createState() => _AppSearchDelegateState();
}

class _AppSearchDelegateState extends State<AppSearchDelegate>
    with AutomaticKeepAliveClientMixin {
  String _keyword = '';

  TopicListSortType _sortType = TopicListSortType.viewCount;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: DiscuzAppBar(
        title: '发现与话题',
        brightness: Brightness.light,
      ),
      body: Column(
        children: <Widget>[
          TopicListBar(
            onKeyWordChanged: (String val) {
              setState(() {
                _keyword = val;
              });
            },
            onSortChanged: (TopicListSortType val) {
              setState(() {
                _sortType = val;
              });
            },
          ),
          Expanded(
            child: TopicsList(
              keyword: _keyword,
              sort: _sortType,
            ),
          )
        ],
      ),
    );
  }
}
