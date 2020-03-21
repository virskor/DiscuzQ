import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncluedes.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/threads/ThreadCard.dart';

///------------------------------
/// _threadsCacher 是用于缓存当前页面的主题数据的对象
/// 当数据更新的时候，数据会存储到 _threadsCacher
/// _threadsCacher 在页面销毁的时候，务必清空 .clear()
///
final ThreadsCacher _threadsCacher = ThreadsCacher();

///
/// 我的收藏
class MyCollectionDelegate extends StatefulWidget {
  const MyCollectionDelegate({Key key}) : super(key: key);
  @override
  _MyCollectionDelegateState createState() => _MyCollectionDelegateState();
}

class _MyCollectionDelegateState extends State<MyCollectionDelegate> {
  ///
  /// 下拉刷新
  ///
  final RefreshController _controller = RefreshController();

  /// states
  ///
  /// pagenumber
  int _pageNumber = 1;

  /// meta required threadCount && pageCount
  dynamic _meta;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

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
    _threadsCacher.clear();
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
          appBar: DiscuzAppBar(
            title: '我的收藏',
          ),
          backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,

          /// 如果没有更多信息则直接提示用户，没有更多信息了
          body: _body(state: state)));

  /// _body
  /// 生成Body
  Widget _body({AppState state}) {
    if (_loading) {
      return const Center(
        child: const DiscuzIndicator(),
      );
    }

    if (_threadsCacher.threads == null || _threadsCacher.threads.length == 0) {
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
  /// todo: 直接把主题列表做成一个组件好了，这样也不用每个地方一大堆代码
  List<Widget> _buildCollectionsList({AppState state}) => _threadsCacher.threads
      .map<Widget>(
        (ThreadModel it) => ThreadCard(
          thread: it,
        ),
      )
      .toList();

  ///
  /// _requestData will get data from backend
  /// 如果提供了pageNumber则使用指定的pageNumber加载
  /// 如果没有提供，则使用_pageNumber
  Future<void> _requestData({int pageNumber, String keyword}) async {
    ///
    /// 如果是第一页的时候要先清空数据，防止数据重复
    if (_pageNumber <= 1 || pageNumber <= 1) {
      _threadsCacher.clear();
    }

    ///
    /// 正在加载
    ///
    setState(() {
      _loading = true;
    });

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
      setState(() {
        _loading = false;
      });
      DiscuzToast.failed(context: context, message: '加载失败');
      return;
    }

    ///
    /// 更新数据
    /// 更新ThreadsCacher中的数据
    /// 数据更新后 ThreadsCacher.builder 会根据最新的数据来重构Widget tree便会展示最新数据
    final List<dynamic> _threads = resp.data['data'] ?? [];
    final List<dynamic> _included = resp.data['included'] ?? [];

    /// 关联的数据，包含user, post，需要在缓存前进行转义
    try {
      _threadsCacher.threads = _threads
          .map<ThreadModel>((t) => ThreadModel.fromMap(maps: t))
          .toList();
      _threadsCacher.posts = _included
          .where((inc) => inc['type'] == 'posts')
          .map((p) => PostModel.fromMap(maps: p))
          .toList();
      _threadsCacher.users = _included
          .where((inc) => inc['type'] == 'users')
          .map((p) => UserModel.fromMap(maps: p['attributes']))
          .toList();
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
      _pageNumber = resp.data['meta']['pageCount'];
    });
  }
}
