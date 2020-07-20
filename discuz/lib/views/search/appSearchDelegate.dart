import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/views/search/searchSuggestion.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/views/search/searchUserDelegate.dart';
import 'package:discuzq/views/search/searchThreadDelegate.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

enum DiscuzAppSearchType {
  ///
  /// Search for Thread
  thread,

  ///
  /// Search for User
  user,

  ///
  /// Search for topics
  topic
}

class AppSearchDelegate extends StatefulWidget {
  const AppSearchDelegate();
  @override
  _AppSearchDelegateState createState() => _AppSearchDelegateState();
}

class _AppSearchDelegateState extends State<AppSearchDelegate> {
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
          appBar: DiscuzAppBar(title: '搜索与发现', actions: <Widget>[..._actions])));

  ///
  /// search Icon Button
  List<Widget> get _actions => [
        IconButton(
            icon: const DiscuzIcon(
              SFSymbols.doc_text_search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: _DiscuzAppSearchDelegate(
                      type: DiscuzAppSearchType.thread));
            }),
        IconButton(
            icon: const DiscuzIcon(
              SFSymbols.person_badge_plus,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate:
                      _DiscuzAppSearchDelegate(type: DiscuzAppSearchType.user));
            })
      ];
}

class _DiscuzAppSearchDelegate extends SearchDelegate<String> {
  _DiscuzAppSearchDelegate({this.type = DiscuzAppSearchType.thread});

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
  String searchFieldLabel = '输入关键字来继续';

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
