import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/search/searchTypeItemsColumn.dart';

///
/// 显示搜索选项的对话框
/// 
class SearchColumnDialog {
  static Future<void> show(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: 190,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const SearchTypeItemsColumn(),
            ),
          );
        });
  }
}
