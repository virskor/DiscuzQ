import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
              appBar: DiscuzAppBar(
            title: '我的收藏',
          )));
}
