import 'package:flutter/material.dart';

import 'package:core/widgets/forum/forumCategoryFilter.dart';
import 'package:core/widgets/threads/theadsList.dart';
import 'package:core/widgets/ui/ui.dart';

class SearchThreadDelegate extends StatefulWidget {
  const SearchThreadDelegate({this.keyword});

  final String keyword;

  @override
  _SearchThreadDelegateState createState() => _SearchThreadDelegateState();
}

class _SearchThreadDelegateState extends State<SearchThreadDelegate>
    with AutomaticKeepAliveClientMixin {
  /// 筛选条件状态
  ForumCategoryFilterItem _filterItem;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          /// 条件筛选组件
          ForumCategoryFilter(
            onChanged: (ForumCategoryFilterItem item) {
              /// todo: 条件切换啦，重新加载当前版块下的数据
              /// 注意，如果选择的条件相同，那么还是要做忽略return
              if (_filterItem == item) {
                return;
              }

              setState(() {
                _filterItem = item;
              });
            },
          ),
          Expanded(
            child: ThreadsList(
              /// 初始化的时候，用户没有选择，则默认使用第一个筛选条件
              filter: _filterItem ?? ForumCategoryFilter.conditions[0],
              keyword: widget.keyword,
            ),
          )
        ],
      ),
    );
  }
}
