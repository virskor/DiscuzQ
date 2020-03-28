import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/appbar/searchAppbar.dart';
import 'package:discuzq/widgets/search/searchHistoryList.dart';
import 'package:discuzq/widgets/search/searchResultTabs.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class TotalSearchDelegate extends StatefulWidget {
  final Function onRequested;

  const TotalSearchDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _TotalSearchDelegateState createState() => _TotalSearchDelegateState();
}

class _TotalSearchDelegateState extends State<TotalSearchDelegate> {
  //// state
  ///
  bool _showHistory = true;

  ///
  /// 关键子
  String _keyword = '';

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
            appBar: SearchAppbar(
              onSubmit: (String keyword, bool showNotice) =>
                  _onSubmit(keyword: keyword, showNotice: showNotice),
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _showHistory == true
                ? const SearchHistoryList()
                : Column(
                    children: <Widget>[
                      Expanded(
                        /// 
                        /// 搜索结果页
                        /// 
                        child: SearchResultTabs(
                          keyword: _keyword,
                        ),
                      )
                    ],
                  ),
          ));

  ///
  /// 提交搜索
  /// 收到事件后 如果输入的文本为空，要显示历史记录
  ///
  void _onSubmit({String keyword, bool showNotice}) {
    if (StringHelper.isEmpty(string: keyword)) {
      setState(() {
        _showHistory = true;
      });

      if (showNotice) {
        DiscuzToast.failed(context: context, message: '缺少关键字');
      }
      return;
    }

    setState(() {
      _showHistory = false;

      /// 为了呈现搜索结果，应该隐藏搜索历史页
      _keyword = keyword;
    });
  }
}
