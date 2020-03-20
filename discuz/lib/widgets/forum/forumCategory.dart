import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';

///
/// 注意：
/// 当filter传入的属性变化时，组件会异步重载，
/// 重载指的是完全从头开始重新筛选，因为此时用户修改了筛选条件
/// 页面下拉则会从头刷新
/// load 上拉则会加载下一页的数据
///
class ForumCategory extends StatefulWidget {
  /// 要显示的分类
  final dynamic category;

  /// 用户查询的筛选条件
  final ForumCategoryFilterItem filter;

  ForumCategory(this.category, {Key key, @required this.filter})
      : super(key: key);

  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ForumCategory> {
  ///
  /// _controller refresh
  ///
  final RefreshController _controller = RefreshController();

  /// states
  ///
  /// pageNumber
  int _pageNumber = 1;

  /// meta required threadCount && pageCount
  dynamic _meta;

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
    _controller.dispose();

    /// do not forget to dispose _controller
    super.dispose();
  }

  ///
  /// 是否允许加载更多页面
  ///
  bool _enablePullUp() =>
      _meta == null ? false : _meta['pageCount'] >= _pageNumber ? false : true;

  ///
  /// DiscuzText(widget.filter.filter.toString())
  @override
  Widget build(BuildContext context) => DiscuzRefresh(
        enablePullDown: true,
        enablePullUp: _enablePullUp(),

        /// 允许乡下加载
        // header: WaterDropHeader(),
        controller: _controller,
        onRefresh: () async {
          _controller.refreshCompleted();
        },
        onLoading: () async {
          _controller.loadComplete();
        },
        child: Column(
          children: <Widget>[
            DiscuzText(widget.filter.includes.toString()),
            DiscuzText(widget.filter.filter.toString())
          ],
        ),
      );

  ///
  /// _requestData will get data from backend
  Future<void> _requestData() async {}
}
