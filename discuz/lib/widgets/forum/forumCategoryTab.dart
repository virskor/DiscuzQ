import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';

class ForumCategory extends StatefulWidget {
  const ForumCategory({Key key}) : super(key: key);
  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ForumCategory> {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: true, builder: (context, child, model) => Container());
}
