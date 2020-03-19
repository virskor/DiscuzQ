import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/search/searchAppbar.dart';
import 'package:discuzq/widgets/search/searchHistoryList.dart';

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
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: SearchAppbar(
              onSubmit: (String keyword, bool showNotice) =>
                  _onSubmit(keyword: keyword, showNotice: showNotice),
            ),
            body: _showHistory == true
                ? const SearchHistoryList()
                : Column(
                    children: <Widget>[],
                  ),
          ));

  ///
  /// 提交搜索
  /// 收到事件后 如果输入的文本为空，要显示历史记录
  ///
  Future<void> _onSubmit({String keyword, bool showNotice}) async {
    if (StringHelper.isEmpty(string: keyword)) {
      setState(() {
        _showHistory = true;
      });

      if (showNotice) {
        DiscuzToast.failed(context: context, message: '请输入关键字在搜索');
      }
      return;
    }

    ///
    setState(() {
      _showHistory = false;
    });

    /// 显示结果展示组件 
    /// （渲染一个listview, 将两个searchReaultview返回的listview合并，得到一个listview）
    /// searchResultView主要构造一个listview, 可以根据 实际情况开启infinite 直接将组件复用
  }
}
