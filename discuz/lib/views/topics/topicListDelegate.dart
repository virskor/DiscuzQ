import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';

class TopicListDelegate extends StatefulWidget {
  TopicListDelegate({@required this.topicID}) {
    assert(topicID != null);
  }

  final int topicID;

  @override
  _TopicListDelegateState createState() => _TopicListDelegateState();
}

class _TopicListDelegateState extends State<TopicListDelegate> {
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '话题ID${widget.topicID.toString()}，加载失败',
            ),
            body: const Center(
              child: const DiscuzText('即将支持'),
            ),
          ));
}
