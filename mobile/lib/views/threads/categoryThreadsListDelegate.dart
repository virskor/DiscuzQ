import 'dart:ui';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/threads/theadsList.dart';
import 'package:discuzq/widgets/forum/forumAddButton.dart';

class CategoryThreadListDelegate extends StatefulWidget {
  const CategoryThreadListDelegate({Key key, this.category}) : super(key: key);

  final CategoryModel category;
  @override
  _CategoryThreadListDelegateState createState() =>
      _CategoryThreadListDelegateState();
}

class _CategoryThreadListDelegateState
    extends State<CategoryThreadListDelegate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiscuzAppBar(
        title: widget.category.attributes.name,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DiscuzApp.themeOf(context).primaryColor,
        child: const DiscuzIcon(
          CupertinoIcons.plus,
          color: Colors.white,
        ),
        onPressed: () {
          showCupertinoModalPopup(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10),
              context: context,
              builder: (BuildContext context) => const Material(
                  color: Colors.transparent,
                  child: const ForumCreateThreadDialog()));
        },
      ),
      body: ThreadsList(
        category: widget.category,
        filter: ForumCategoryFilter.conditions[0],
      ),
    );
  }
}
