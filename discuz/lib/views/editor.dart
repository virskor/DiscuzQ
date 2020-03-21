import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';

class Editor extends StatefulWidget {
  const Editor();

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '发布内容',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: Column(
              children: <Widget>[
                Expanded(child: const Center(child: const DiscuzText('暂不支持'))),
              ],
            ),
          ));
}
