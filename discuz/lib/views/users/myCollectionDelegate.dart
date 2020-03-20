import 'package:dio/dio.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncluedes.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/search/searchAppbar.dart';
import 'package:discuzq/models/userModel.dart';

class MyCollectionDelegate extends StatefulWidget {
  const MyCollectionDelegate({Key key}) : super(key: key);
  @override
  _MyCollectionDelegateState createState() => _MyCollectionDelegateState();
}

class _MyCollectionDelegateState extends State<MyCollectionDelegate> {
  final RefreshController _controller = RefreshController();

  /// states
  ///
  /// pagenumber
  int _pageNumber = 1;

  /// meta required threadCount && pageCount
  dynamic _meta;

  ///
  /// collections
  List<ThreadModel> _collections;

  ///
  /// users
  List<UserModel> _users = [];

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
    _requestData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  /// 是否允许加载更多页面
  ///
  bool _enablePullUp() =>
      _meta == null ? false : _meta['pageCount'] >= _pageNumber ? false : true;

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
          appBar: SearchAppbar(
            placeholder: '输入关键字搜索',
            onSubmit: (String keyword) {
              /// ... 用户输入了关键字
            },
          ),
          backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,

          /// 如果没有更多信息则直接提示用户，没有更多信息了
          body: _body(state: state)));

  /// _body
  /// 生成Body
  Widget _body({AppState state}) {
    if (_collections == null || _collections.length == 0) {
      return const DiscuzNoMoreData();
    }

    return DiscuzRefresh(
      controller: _controller,
      enablePullUp: _enablePullUp(),
      enablePullDown: true,
      onRefresh: () async {
        /// ... 刷新的时候，要将页面_pagenumber更新到第一页
        setState(() {
          _pageNumber = 1;
        });

        await _requestData();
        _controller.refreshCompleted();
      },

      /// 允许刷新
      child: ListView(
        children: _buildCollectionsList(state: state),
      ),
    );
  }

  ///
  /// 构造收藏的列表
  ///
  List<Widget> _buildCollectionsList({AppState state}) => _collections
      .map((it) => Column(
            children: <Widget>[
              ///
              /// 显示主题顶部信息
              /// todo: 移除，这个组件，直接使用已经封装的ThreadCard组件进行渲染即可
              // ThreadHeaderCard(
              //   thread: it,
              // ),
              const DiscuzText('测试')
            ],
          ))
      .toList();

  ///
  /// _requestData will get data from backend
  /// 如果提供了pageNumber则使用指定的pageNumber加载
  /// 如果没有提供，则使用_pageNumber
  Future<void> _requestData({int pageNumber, String keyword}) async {
    ///
    /// 关联查询的数据
    /// 
    List<String> includes = [
      RequestIncludes.user,
      RequestIncludes.firstPost,
      RequestIncludes.firstPostLikedUsers,
      RequestIncludes.lastThreePosts,
      RequestIncludes.lastThreePostsUser,
      RequestIncludes.rewardedUsers
    ];

    dynamic data = {
      "page['limit']": Global.requestPageLimit,
      "page['pageNumber']": pageNumber ?? _pageNumber,
      "include": RequestIncludes.toGetRequestQueries(includes: includes),
    };
    Response resp = await Request(context: context)
        .getUrl(url: Urls.threadsFavorites, queryParameters: data);

    if (resp == null) {
      DiscuzToast.failed(context: context, message: '加载失败');
      return;
    }

    ///
    /// 更新数据
    setState(() {
      
    });
  }
}
