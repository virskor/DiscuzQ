import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/forum/forumCategory.dart';
import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';

/// 注意：
/// 从我们的设计上来说，要加载了forum才显示这个组件，所以forum请求自然就在category之前
/// 这样做的目的是为了不要一次性请求过多，来尽量避免阻塞，所以在使用这个组件到其他地方渲染的时候，你也需要这样做
class ForumCategoryTab extends StatefulWidget {
  const ForumCategoryTab({Key key}) : super(key: key);
  @override
  _ForumCategoryTabState createState() => _ForumCategoryTabState();
}

class _ForumCategoryTabState extends State<ForumCategoryTab>
    with SingleTickerProviderStateMixin {
  /// states
  /// tab controller
  TabController _tabController;

  /// _loading will be true when request categories, but not tell you success or failed to load
  /// default should be true, so that you can make a loading animation for users
  bool _loading = true;

  /// categories is empty
  bool _isEmptyCategories = false;

  /// 筛选条件状态
  ForumCategoryFilterItem _filterItem;

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

    /// 延迟加载
    Future.delayed(Duration(milliseconds: 400))
        .then((_) => this._initTabController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => _buildForumCategoryTabTab(state));

  /// 构造tabbar
  Widget _buildForumCategoryTabTab(AppState state) {
    /// 返回加载中的视图
    if (_loading) {
      return const Center(
        child: const DiscuzIndicator(),
      );
    }

    /// 返回没有可用分类
    if (_isEmptyCategories) {
      const Center(child: const DiscuzText('暂无可用分类'));
    }

    /// 生成论坛分类和内容区域
    return Column(
      children: <Widget>[
        /// 生成滑动选项
        _buildtabs(state),

        /// 条件筛选组件
        ForumCategoryFilter(
          onChanged: (ForumCategoryFilterItem item) {
            /// todo: 条件切换啦，重新加载当前版块下的数据
            /// 注意，如果选择的条件相同，那么还是要做忽略return
            if (_filterItem == item) {
              return;
            }

            print(item.filter.toString());
            setState(() {
              _filterItem = item;
            });
          },
        ),

        /// 生成帖子渲染content区域(tabviews)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: state.categories.map<Widget>((cat) {
              //创建3个Tab页
              return ForumCategory(
                cat,

                /// 初始化的时候，用户没有选择，则默认使用第一个筛选条件
                filter: _filterItem ?? ForumCategoryFilter.conditions[0],
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildtabs(AppState state) => Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
        child: TabBar(
            //生成Tab菜单
            controller: _tabController,
            labelStyle: TextStyle(
              //up to your taste
              fontSize: DiscuzApp.themeOf(context).normalTextSize,
            ),
            indicatorSize: TabBarIndicatorSize.label, //makes it better
            labelColor:
                DiscuzApp.themeOf(context).primaryColor, //Google's sweet blue
            unselectedLabelColor:
                DiscuzApp.themeOf(context).textColor, //niceish grey
            isScrollable: true, //up to your taste
            indicator: MD2Indicator(
                //it begins here
                indicatorHeight: 2,
                indicatorColor: DiscuzApp.themeOf(context).primaryColor,
                indicatorSize:
                    MD2IndicatorSize.normal //3 different modes tiny-normal-full
                ),
            tabs: state.categories
                .map<Widget>((e) => Tab(text: e['attributes']['name']))
                .toList()),
      );

  /// 初始化 tab controller
  ///
  /// 该方法将会请求查询分类接口以构造一个 tabs 列表
  ///
  Future<void> _initTabController() async {
    try {
      final AppState state =
          ScopedModel.of<AppState>(context, rebuildOnChange: true);

      final bool success = await _getCategories(state);
      if (!success) {
        return;
      }

      /// 没有分类
      if (state.categories == null || state.categories.length == 0) {
        setState(() {
          _isEmptyCategories = true;
        });
      }

      /// 初始化tabber
      _tabController = TabController(
          length: state.categories == null ? 0 : state.categories.length,
          vsync: this);
    } catch (e) {
      print(e);
    }
  }

  ///
  /// _getCategories
  /// force should never be true on didChangeDependencies life cycle
  /// that would make your ui rendering loop and looping to die
  /// 
  Future<bool> _getCategories(AppState state, {bool force = false}) async {
    setState(() {
      _loading = true;
      _isEmptyCategories = false;

      /// 仅需要复原 _initTabController会再次处理
    });

    Response resp =
        await Request(context: context).getUrl(url: Urls.categories);

    setState(() {
      _loading = false;
    });

    if (resp == null) {
      return Future.value(false);
    }

    /// 增加一个全部
    List<dynamic> categories = resp.data['data'];
    categories.insert(0, {
      "type": "categories",
      "id": null,
      "attributes": {
        "name": "全部",
        "description": "圈闭分类",
        "icon": "",
        "sort": 0,
        "property": 0,
        "thread_count": 0,
        "ip": "",
        "created_at": "",
        "updated_at": ""
      }
    });

    /// 更新状态
    state.updateCategories(categories);

    return Future.value(true);
  }
}
