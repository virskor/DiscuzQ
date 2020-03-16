import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

/// 默认的筛选条件
const List<ForumCategoryFilterItem> conditions = [
  const ForumCategoryFilterItem(
    label: '全部主题',
    filter: [],
  ),
  const ForumCategoryFilterItem(label: '精华主题', filter: []),
  const ForumCategoryFilterItem(label: '已关注的', filter: []),
];

/// 筛选组件
class ForumCategoryFilter extends StatefulWidget {
  /// 筛选条件发生变化
  final Function onChanged;

  ForumCategoryFilter({this.onChanged});

  @override
  _ForumCategoryFilterState createState() => _ForumCategoryFilterState();
}

class _ForumCategoryFilterState extends State<ForumCategoryFilter> {
  /// states
  ForumCategoryFilterItem _selected = conditions[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).backgroundColor,
          border: Border(top: Global.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// 显示当前的筛选模式
          DiscuzText(_selected.label),

          /// 下拉筛选组件
          DiscuzText(_selected.label)
        ],
      ),
    );
  }
}

/// ForumCategoryFilterItem 过滤条件选项
class ForumCategoryFilterItem {
  /// 默认的关联数据
  static const String _defaultIncludes =
      'user,firstPost,firstPost.images,lastThreePosts,lastThreePosts.user,lastThreePosts.replyUser,firstPost.likedUsers,rewardedUsers';

  /// 用于筛选的条件的标签
  final String label;

  /// 用于请求的值
  final List<Map<String, String>> filter;

  /// 查询时所需的关联数据
  final String includes;

  const ForumCategoryFilterItem(
      {@required this.label,
      @required this.filter,
      this.includes = _defaultIncludes});
}
