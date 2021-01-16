import 'package:flutter/material.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/topics/topicsList.dart';
import 'package:discuzq/widgets/topics/topicListBar.dart';
import 'package:discuzq/widgets/topics/topicSortTypes.dart';

class AppTopicsDelegate extends StatefulWidget {
  const AppTopicsDelegate();
  @override
  _AppTopicsDelegateState createState() => _AppTopicsDelegateState();
}

class _AppTopicsDelegateState extends State<AppTopicsDelegate>
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
        title: '话题',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TopicListBar(
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
        ),
      ),
      body: TopicsList(
        keyword: _keyword,
        sort: _sortType,
      ),
    );
  }
}
