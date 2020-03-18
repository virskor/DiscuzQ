import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class FollowingDelegate extends StatefulWidget {
  const FollowingDelegate({Key key}) : super(key: key);
  @override
  _FollowingDelegateState createState() => _FollowingDelegateState();
}

class _FollowingDelegateState extends State<FollowingDelegate> {
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
            elevation: 10,
            title: '我的关注',
          )));
}
