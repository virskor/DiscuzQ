import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/utils/request/requestIncluedes.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor,
                border: Border(top: Global.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /// 显示当前的筛选模式
                /// 绑定当前选中项目的label
                DiscuzText(_selected.label),

                /// 下拉筛选组件
                _buildPopMenu(state)
              ],
            ),
          ));

  /// 下拉弹出菜单
  Widget _buildPopMenu(AppState state) {
    /// 部分条件需要用户登录的时候才显示
    /// 先构造筛选列表
    final List<PopupMenuItem<ForumCategoryFilterItem>> items =
        ForumCategoryFilter.conditions
            .map<PopupMenuItem<ForumCategoryFilterItem>>(
                (ForumCategoryFilterItem c) =>
                    c.shouldLogin == true && state.user == null
                        ? null
                        : PopupMenuItem<ForumCategoryFilterItem>(
                            //checked: _selected == c,
                            value: c,
                            child: DiscuzText(
                              c.label,
                            ),
                          ))
            .toList();

    ///
    /// 构造菜单
    return PopupMenuButton(
        itemBuilder: (BuildContext context) => items,
        //child: DiscuzText(_selected.label),
        color: DiscuzApp.themeOf(context).backgroundColor,
        icon: DiscuzIcon(
          SFSymbols.slider_horizontal_3,
          color: DiscuzApp.themeOf(context).primaryColor,
        ),
        padding: const EdgeInsets.all(0),
        onSelected: (ForumCategoryFilterItem val) {
          /// 先拷贝过滤参数
          List<Map<String, dynamic>> rebuildFilterList = [...val.filter];

          /// 构造一个全新的filter进行强制替换
          if (val.shouldLogin == true) {
            Map<String, dynamic> replacement = {
              "fromUserId": state.user.id,
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
  }
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
