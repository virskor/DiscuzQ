import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzText.dart';

class SearchHistoryList extends StatefulWidget {
  const SearchHistoryList({Key key}) : super(key: key);
  @override
  _SearchHistoryListState createState() => _SearchHistoryListState();
}

class _SearchHistoryListState extends State<SearchHistoryList> {
  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _NoAvailableKeywords();
  }
}


///
/// 没有可用的搜索历史关键字
/// 
class _NoAvailableKeywords extends StatelessWidget {
  const _NoAvailableKeywords();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const DiscuzText('暂无搜索记录'),
    );
  }
}
