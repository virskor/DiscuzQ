import 'package:flutter/material.dart';

import 'package:discuzq/views/searchAndExplore/searchSuggestion.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/views/searchAndExplore/searchUserDelegate.dart';
import 'package:discuzq/views/searchAndExplore/searchThreadDelegate.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/topics/topicsList.dart';
import 'package:discuzq/widgets/topics/topicListBar.dart';
import 'package:discuzq/widgets/topics/topicSortTypes.dart';

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

class _AppSearchDelegateState extends State<AppSearchDelegate>
    with AutomaticKeepAliveClientMixin {
  String _keyword = '';

  TopicListSortType _sortType = TopicListSortType.viewCount;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: DiscuzAppBar(title: '发现与话题', actions: <Widget>[..._actions]),
      body: Column(
        children: <Widget>[
          TopicListBar(
            onKeyWordChanged: (String val) {
              setState(() {
                _keyword = val;
              });
            },
            onSortChanged: (TopicListSortType val) {
              setState(() {
                _sortType = val;
              });
            },
          ),
          Expanded(
            child: TopicsList(
              keyword: _keyword,
              sort: _sortType,
            ),
          )
        ],
      ),
    );
  }

  ///
  /// search Icon Button
  List<Widget> get _actions => [
        const _DiscuzAppSearchActionButton(
          type: DiscuzAppSearchType.thread,
          caption: '搜主题',
        ),
        const _DiscuzAppSearchActionButton(
          type: DiscuzAppSearchType.user,
          caption: '搜用户',
        ),
      ];
}

class _DiscuzAppSearchActionButton extends StatelessWidget {
  const _DiscuzAppSearchActionButton(
      {this.type = DiscuzAppSearchType.thread, this.caption = '搜主题'});

  final DiscuzAppSearchType type;

  final String caption;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
          constraints: BoxConstraints(maxHeight: 45),
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
              color: const Color(0xFF00000),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  DiscuzText(
                    caption,
                    color: const Color(0xFFDEDEDE),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const DiscuzIcon(
                    SFSymbols.chevron_right,
                    size: 14,
                    color: const Color(0xFFDEDEDE),
                  )
                ],
              )),
        ),
        onTap: () => showSearch(
            context: context, delegate: _DiscuzAppSearchDelegate(type: type)),
      );
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
