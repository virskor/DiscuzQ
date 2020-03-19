import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class BlackListDelegate extends StatefulWidget {
  const BlackListDelegate({Key key}) : super(key: key);
  @override
  _BlackListDelegateState createState() => _BlackListDelegateState();
}

class _BlackListDelegateState extends State<BlackListDelegate> {
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
            title: '黑名单',
          )));
}
