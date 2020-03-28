import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/search/searchTypeItemsColumn.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/search/searchHistoryList.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class TotalSearchDelegate extends StatefulWidget {
  final Function onRequested;

  const TotalSearchDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _TotalSearchDelegateState createState() => _TotalSearchDelegateState();
}

class _TotalSearchDelegateState extends State<TotalSearchDelegate> {
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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '搜索',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: Column(
              children: <Widget>[
                ///
                /// 搜索分类导航
                /// 
                const SearchTypeItemsColumn(),
                ///
                /// 展现搜索历史关键子列表
                Expanded(
                  child: SearchHistoryList(),
                )
              ],
            ),
          ));
}
