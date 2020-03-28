import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/editor/discuzEditor.dart';

class Editor extends StatefulWidget {
  const Editor();

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ///
  /// uniqueKey
  final UniqueKey uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            key: uniqueKey,
            appBar: DiscuzAppBar(
              title: '发布内容',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: Column(
              children: <Widget>[
                Expanded(child: DiscuzEditor()),
              ],
            ),
          ));
}
