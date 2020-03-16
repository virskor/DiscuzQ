import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:flutter/material.dart';

class ForumCategory extends StatefulWidget {
  /// 要显示的分类
  final dynamic category;

  /// 用户查询的筛选条件
  final ForumCategoryFilterItem filter;

  ForumCategory(this.category, {Key key, @required this.filter})
      : super(key: key);
  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ForumCategory> {

  @override
  void initState() {
    super.initState();
    print(widget.filter);
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          DiscuzText(widget.category['attributes']['name'], textScaleFactor: 5),
    );
  }
}
