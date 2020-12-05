import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/ui/ui.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/utils/request/requestIncludes.dart';
import 'package:core/providers/userProvider.dart';

/// 筛选组件
class ForumCategoryFilter extends StatefulWidget {
  /// 筛选条件发生变化
  final Function onChanged;

  /// 默认的筛选条件
  static const List<ForumCategoryFilterItem> conditions = [
    const ForumCategoryFilterItem(
      label: '全部主题',
      filter: [
        {"isApproved": 1},
        {"isDeleted": "no"}
      ],
    ),
    const ForumCategoryFilterItem(
      label: '精华主题',
      filter: [
        {"isApproved": 1},
        {"isDeleted": "no"},
        {"isEssence": "yes"}
      ],
    ),

    ///
    /// 注意，用于筛选已关注的要在登录条件下才会显示
    /// 该条件中的参数 fromUserId 将会在选择时被自动更新
    /// 更新过程参考 ForumCategoryFilter 组件中的 onChanged 回调过程
    const ForumCategoryFilterItem(
      label: '已关注的',
      shouldLogin: true,
      filter: [
        {"isApproved": 1},
        {"isDeleted": "no"},
        {"fromUserId": ""},

        /// uid will be auto matically replaced on requesting data, do not change
        /// replace uid procedure performed at ForumCategoryFilter widget.
      ],
    ),
  ];

  ForumCategoryFilter({this.onChanged});

  @override
  _ForumCategoryFilterState createState() => _ForumCategoryFilterState();
}

class _ForumCategoryFilterState extends State<ForumCategoryFilter> {
  /// states
  ForumCategoryFilterItem _selected = ForumCategoryFilter.conditions[0];

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider user, Widget child) {
        final List<PopupMenuItem<ForumCategoryFilterItem>> items =
            ForumCategoryFilter.conditions
                .map<PopupMenuItem<ForumCategoryFilterItem>>(
                    (ForumCategoryFilterItem c) =>
                        c.shouldLogin == true && !user.hadLogined
                            ? null
                            : PopupMenuItem<ForumCategoryFilterItem>(
                                //checked: _selected == c,
                                value: c,
                                child: DiscuzText(
                                  c.label,
                                ),
                              ))
                .toList();

        final Widget _popMenu = PopupMenuButton(
            itemBuilder: (BuildContext context) => items,
            //child: DiscuzText(_selected.label),
            color: DiscuzApp.themeOf(context).backgroundColor,
            icon: DiscuzIcon(
              Icons.more_horiz,
              color: DiscuzApp.themeOf(context).textColor,
            ),
            onSelected: (ForumCategoryFilterItem val) {
              /// 先拷贝过滤参数
              List<Map<String, dynamic>> rebuildFilterList = [...val.filter];

              /// 构造一个全新的filter进行强制替换
              if (val.shouldLogin == true) {
                Map<String, dynamic> replacement = {
                  "fromUserId": context.read<UserProvider>().user.attributes.id,
                };

                /// 过滤可能发生重复的数据
                rebuildFilterList = rebuildFilterList
                    .where((it) => it.keys.first != "fromUserId")
                    .toList();
                rebuildFilterList.add(replacement);
              }

              /// 新建一个新的item对象用于反馈用户选择的条件
              ForumCategoryFilterItem givingItem = ForumCategoryFilterItem(
                  includes: val.includes,
                  shouldLogin: val.shouldLogin,
                  label: val.label,
                  filter: rebuildFilterList);

              setState(() {
                _selected = givingItem;
              });

              if (widget.onChanged != null) {
                widget.onChanged(givingItem);
              }
            });

        return Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            left: 10,
            right: 0,
          ),
          decoration: BoxDecoration(
              color: DiscuzApp.themeOf(context).backgroundColor,
              border: const Border(top: Global.border, bottom: Global.border)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// 显示当前的筛选模式
              /// 绑定当前选中项目的label
              DiscuzText(_selected.label),

              /// 下拉筛选组件
              _popMenu
            ],
          ),
        );
      });
}

/// ForumCategoryFilterItem 过滤条件选项
class ForumCategoryFilterItem {
  /// 默认的关联数据
  static const List<String> _defaultIncludes = <String>[
    RequestIncludes.user,
    RequestIncludes.thread,
    RequestIncludes.firstPost,
    RequestIncludes.firstPostImages,
    RequestIncludes.firstPostLikedUsers,
    RequestIncludes.rewardedUsers,
    RequestIncludes.lastThreePosts,
    RequestIncludes.lastThreePostsUser,
    RequestIncludes.lastThreePostsReplyUser,
  ];

  /// 用于筛选的条件的标签
  final String label;

  /// 用于请求的值
  final List<Map<String, dynamic>> filter;

  /// 查询时所需的关联数据
  final List<dynamic> includes;

  /// 是否需要登录才显示
  final bool shouldLogin;

  const ForumCategoryFilterItem(
      {@required this.label,
      @required this.filter,
      this.shouldLogin = false,
      this.includes = _defaultIncludes});
}
