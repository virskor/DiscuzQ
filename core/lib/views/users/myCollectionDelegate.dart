import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:core/widgets/common/discuzNomoreData.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/utils/global.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/requestIncludes.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/threads/threadsCacher.dart';
import 'package:core/widgets/threads/threadCard.dart';
import 'package:core/models/metaModel.dart';
import 'package:core/widgets/skeleton/discuzSkeleton.dart';

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
  MetaModel _meta;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

  ///
  /// _continueToRead
  /// 是否是联系加载
  bool _continueToRead = false;

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
  /// 是否允许加载更多
  bool get _enablePullUp => _meta == null
      ? false
      : _meta.pageCount > _pageNumber
          ? true
          : false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: DiscuzAppBar(
        title: '我的收藏',
        brightness: Brightness.light,
      ),
      body: _body());

  /// _body
  /// 生成Body
  Widget _body() {
    ///
    /// 仅在第一次加载骨架屏
    if (_loading && !_continueToRead) {
      return const Center(
        child: const DiscuzSkeleton(
          isCircularImage: false,
          isBottomLinesActive: true,
        ),
      );
    }

    ///
    /// 如果没有更多信息则直接提示用户，没有更多信息了
    ///
    if (!_loading && _threadsCacher.threads == null ||
        _threadsCacher.threads.length == 0) {
      return const DiscuzNoMoreData();
    }

    return DiscuzRefresh(
      controller: _controller,
      enablePullUp: _enablePullUp,
      enablePullDown: true,
      onRefresh: () async {
        /// ... 刷新的时候，要将页面_pagenumber更新到第一页
        setState(() {
          _pageNumber = 1;
        });

        await _requestData(pageNumber: 1);
        _controller.refreshCompleted();
      },
      onLoading: () async {
        if (_loading) {
          return;
        }

        await _requestData(pageNumber: _pageNumber + 1);
        _controller.refreshCompleted();
      },

      /// 允许刷新
      child: ListView.builder(
        itemCount: _threadsCacher.threads.length,
        itemBuilder: (context, index) => ThreadCard(
          threadsCacher: _threadsCacher,
          thread: _threadsCacher.threads[index],
          initiallyExpanded: true,
        ),
      ),
    );
  }

  ///
  /// _requestData will get data from backend
  /// 如果提供了pageNumber则使用指定的pageNumber加载
  /// 如果没有提供，则使用_pageNumber
  Future<void> _requestData({int pageNumber}) async {
    ///
    /// 如果是第一页的时候要先清空数据，防止数据重复
    if (pageNumber == 1) {
      ///
      /// 仅更新_continueToRead 不Build UI, 因为下面的 set _loading 其实会触发UI Build，所以不需要再这里也触发
      _continueToRead = false;
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
      "page[limit]": Global.requestPageLimit,
      "page[number]": pageNumber ?? _pageNumber,
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
    final List<dynamic> threads = resp.data['data'] ?? [];
    final List<dynamic> included = resp.data['included'] ?? [];

    /// 关联的数据，包含user, post，需要在缓存前进行转义
    try {
      await _threadsCacher.computeThreads(threads: threads);
      await _threadsCacher.computeUsers(include: included);
      await _threadsCacher.computePosts(include: included);
      await _threadsCacher.computeAttachements(include: included);
      await _threadsCacher.computeThreadVideos(include: included);
    } catch (e) {
      throw e;
    }

    setState(() {
      _loading = false;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;

      /// pageNumber 在onload传入时已经自动加1
      _continueToRead = true;

      /// 修改
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
    });
  }
}
