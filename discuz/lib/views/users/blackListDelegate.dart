import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '黑名单',
              brightness: Brightness.light,
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: const Center(child: const DiscuzText('暂无黑名单记录')),
          ));
}
