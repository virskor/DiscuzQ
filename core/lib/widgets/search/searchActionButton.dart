import 'package:flutter/material.dart';

import 'package:core/widgets/ui/ui.dart';
import 'package:core/views/search/searchSuggestion.dart';
import 'package:core/views/search/searchUserDelegate.dart';
import 'package:core/views/search/searchThreadDelegate.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/search/searchTypeItemsColumn.dart';

class DiscuzAppSearchActionButton extends StatelessWidget {
  const DiscuzAppSearchActionButton(
      {this.type = DiscuzAppSearchType.thread, this.icon});

  ///
  /// 搜索的类型
  final DiscuzAppSearchType type;

  ///
  /// 搜索的按钮图标
  final dynamic icon;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: DiscuzIcon(icon ?? Icons.search, color: Colors.white),
        onPressed: () => showSearch(
            context: context, delegate: DiscuzAppSearchDelegate(type: type)),
      );
}

class DiscuzAppSearchDelegate extends SearchDelegate<String> {
  DiscuzAppSearchDelegate({this.type = DiscuzAppSearchType.thread});

  final DiscuzAppSearchType type;

  @override
  List<Widget> buildActions(BuildContext context) {
    ///显示在最右边的控件列表
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";

          ///搜索建议的内容
          this.showSuggestions(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          this.showResults(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  String searchFieldLabel = '输入关键字来搜索';

  @override
  Widget buildResults(BuildContext context) {
    if (type == DiscuzAppSearchType.user) {
      return SizedBox.expand(
          child: SearchUserDelegate(
        keyword: this.query,
      ));
    }

    if (type == DiscuzAppSearchType.thread) {
      return SizedBox.expand(
          child: SearchThreadDelegate(
        keyword: this.query,
      ));
    }

    return Center(
      child: Text('暂不支持'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SearchSuggestion();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(primaryColor: DiscuzApp.themeOf(context).primaryColor);
  }
}
