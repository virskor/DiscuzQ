import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

class ForumCategory extends StatefulWidget {
  /// 要显示的分类
  final dynamic category;

  ForumCategory(this.category, {Key key}) : super(key: key);
  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ForumCategory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          DiscuzText(widget.category['attributes']['name'], textScaleFactor: 5),
    );
  }
}


class _ForumCategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}