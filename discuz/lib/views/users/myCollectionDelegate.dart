import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class MyCollectionDelegate extends StatefulWidget {
  const MyCollectionDelegate({Key key}) : super(key: key);
  @override
  _MyCollectionDelegateState createState() => _MyCollectionDelegateState();
}

class _MyCollectionDelegateState extends State<MyCollectionDelegate> {
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
              appBar: DiscuzAppBar(
            title: '我的收藏',
          )));
}
