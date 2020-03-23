import 'package:discuzq/widgets/search/searchAppbar.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';

class FollowerListDelegate extends StatefulWidget {
  const FollowerListDelegate({Key key}) : super(key: key);
  @override
  _FollowerListDelegateState createState() => _FollowerListDelegateState();
}

class _FollowerListDelegateState extends State<FollowerListDelegate> {
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
              placeholder: '输入要查找的用户名',
              onSubmit: () => null,
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: ListView(),
          ));

  ///
  /// 查找关注我的用户
  Future<void> _requestData() async{

  }
}
