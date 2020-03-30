import 'package:discuzq/widgets/appbar/searchAppbar.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/threads/theadsList.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

class SearchThreadDelegate extends StatefulWidget {
  const SearchThreadDelegate();
  @override
  _SearchThreadDelegateState createState() => _SearchThreadDelegateState();
}

class _SearchThreadDelegateState extends State<SearchThreadDelegate> {
  ///
  /// states
  ///
  String _keyword;

  /// 筛选条件状态
  ForumCategoryFilterItem _filterItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppbar(
        placeholder: '输入关键字搜索用户',
        onSubmit: (String keyword, bool shouldShowNoticeEmpty) async {
          if (shouldShowNoticeEmpty && keyword == "") {
            DiscuzToast.failed(context: context, message: '缺少关键字');
            return;
          }
          setState(() {
            _keyword = keyword;
          });
        },
      ),
      backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
      body: _buildThreadList(),
    );
  }

  Widget _buildThreadList() => Column(
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
              keyword: _keyword,
            ),
          )
        ],
      );
}
