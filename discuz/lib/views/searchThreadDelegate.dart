import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class SearchThreadDelegate extends StatefulWidget {
  final Function onRequested;

  const SearchThreadDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _SearchThreadDelegateState createState() => _SearchThreadDelegateState();
}

class _SearchThreadDelegateState extends State<SearchThreadDelegate> {
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
              appBar: DiscuzAppBar(
            elevation: 10,
            centerTitle: true,
            title: '搜索',
          )));
}
