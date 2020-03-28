import 'package:flutter/material.dart';

import '../common/discuzText.dart';

class DiscuzEditor extends StatefulWidget {
  @override
  _DiscuzEditorState createState() => _DiscuzEditorState();
}

class _DiscuzEditorState extends State<DiscuzEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: DiscuzText('暂不支持'),
      ),
    );
  }
}
