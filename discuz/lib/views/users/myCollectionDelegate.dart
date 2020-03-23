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
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/threads/ThreadCard.dart';
import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';

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
  /// _enablePullUp
  /// 是否允许加载更多
  bool _enablePullUp = false;

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
  /// 是否允许加载更多页面
  ///
  void _refreshEnablePullUp() {
    final bool enabled =
        _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;
    _enablePullUp = enabled;
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
          appBar: DiscuzAppBar(
            title: '我的收藏',
          ),
          backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,

          body: _body(state: state)));

  /// _body
  /// 生成Body
  Widget _body({AppState state}) {
    ///
    /// 仅在第一次加载骨架屏
    if (_loading && !_continueToRead) {
      return const Center(
        child: const DiscuzSkeleton(
          isCircularImage: false,
          length: Global.requestPageLimit,
          isBottomLinesActive: true,
        ),
      );
    }

    ///
    /// 如果没有更多信息则直接提示用户，没有更多信息了
    /// 
    if (!_loading && _threadsCacher.threads == null || _threadsCacher.threads.length == 0) {
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
      child: ListView(
        shrinkWrap: true,
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
          threadsCacher: _threadsCacher,
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
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;  /// pageNumber 在onload传入时已经自动加1
      _continueToRead = true;
      /// 修改
      _meta = MetaModel.fromMap(maps: resp.data['meta']);

      _refreshEnablePullUp();
    });
  }
}
