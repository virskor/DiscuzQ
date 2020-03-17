import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/search/searchAppbar.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';

class SearchThreadDelegate extends StatefulWidget {
  final Function onRequested;

  const SearchThreadDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _SearchThreadDelegateState createState() => _SearchThreadDelegateState();
}

class _SearchThreadDelegateState extends State<SearchThreadDelegate> {
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
              onSubmit: (String keyword) => _onSubmit(keyword: keyword),
            ),
            body: Column(
              children: <Widget>[],
            ),
          ));

  ///
  /// 提交搜索
  ///
  Future<void> _onSubmit({String keyword}) async {
    if (StringHelper.isEmpty(string: keyword)) {
      DiscuzToast.failed(context: context, message: '请输入关键字在搜索');
      return;
    }
  }
}
