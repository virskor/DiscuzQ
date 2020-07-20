import 'package:dio/dio.dart';
import 'package:discuzq/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncludes.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/threads/threadCard.dart';
import 'package:discuzq/widgets/threads/threadsCacher.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

///
/// 注意：
/// 当filter传入的属性变化时，组件会异步重载，
/// 重载指的是完全从头开始重新筛选，因为此时用户修改了筛选条件
/// 页面下拉则会从头刷新
/// load 上拉则会加载下一页的数据
///
///
///

class ThreadsList extends StatefulWidget {
  /// 要显示的分类
  final CategoryModel category;

  /// 要关联查询的关键子
  /// filter[q]=
  final String keyword;

  ///
  /// onAppbarState
  final Function onAppbarState;

  /// 用户查询的筛选条件
  final ForumCategoryFilterItem filter;

  ThreadsList(
      {Key key,
      this.category,
      this.onAppbarState,
      @required this.filter,
      this.keyword})
      : super(key: key);

  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ThreadsList> {
  ///
  /// _controller refresh
  ///
  final RefreshController _controller = RefreshController();

  ///
  /// _scrollController
  /// 列表滑动，用于决定是否影藏appbar
  final ScrollController _scrollController = ScrollController();

  ///------------------------------
  /// _threadsCacher 是用于缓存当前页面的主题数据的对象
  /// 当数据更新的时候，数据会存储到 _threadsCacher
  /// _threadsCacher 在页面销毁的时候，务必清空 .clear()
  ///
  final ThreadsCacher _threadsCacher = ThreadsCacher();

  /// debouncer
  final Debouncer _debouncer = Debouncer(milliseconds: 470);

  /// states
  ///
  /// pageNumber
  int _pageNumber = 1;

  /// meta required threadCount && pageCount
  MetaModel _meta;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = true;

  ///
  /// _continueToRead
  /// 是否是连续加载
  bool _continueToRead = false;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void didUpdateWidget(ThreadsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget == null) {
      return;
    }

    ///
    /// 如果 filter 发生变化，和上次filter不同那么就是发生变化
    /// 这时候刷新请求变化
    if (oldWidget.filter != widget.filter) {
      Future.delayed(Duration(milliseconds: 450))
          .then((_) async => await _requestData(pageNumber: 1));
    }

    ///
    /// 如果keyword 证明用户重新输入了关键字，那么久执行重新请求
    if (widget.keyword != null && oldWidget.keyword != widget.keyword) {
      Future.delayed(Duration(milliseconds: 450))
          .then((_) async => await _requestData(pageNumber: 1));
    }
  }

  @override
  void initState() {
    super.initState();

    ///
    /// 绑定列表移动时间观察
    this._watchScrollOffset();

    ///
    /// 如果没有提供绑定的分类，可能是意图调用查询生成列表
    /// 那么不需要自动加载数据
    if (widget.category != null) {
      Future.delayed(Duration(milliseconds: 450))
          .then((_) async => await _requestData(pageNumber: 1));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _threadsCacher.clear();

    /// 清空缓存的主题列表数据
    /// do not forget to dispose _controller
    super.dispose();
  }

  ///
  /// 观察列表移动
  /// 观察移动要传递变化时候的值并减少传递，避免UI渲染过程中的Loop造成性能消耗
  ///
  void _watchScrollOffset() {
    bool showAppbar = true;

    _scrollController.addListener(() {
      _debouncer.run(() {
        final bool wantHide = _scrollController.offset >= 300 ? false : true;

        if (widget.onAppbarState != null && wantHide != showAppbar) {
          widget.onAppbarState(wantHide);
          showAppbar = wantHide;
        }
      });
    });
  }

  ///
  /// 是否允许加载更多
  bool get _enablePullUp =>
      _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) =>
          _body(context: context, state: state));

  /// build body
  Widget _body({@required BuildContext context, @required AppState state}) =>
      DiscuzRefresh(
        enablePullDown: true,
        enablePullUp: _enablePullUp,

        /// 允许乡下加载
        // header: WaterDropHeader(),
        controller: _controller,
        onRefresh: () async {
          await _requestData(pageNumber: 1);
          _controller.refreshCompleted();
        },
        onLoading: () async {
          if (_loading) {
            return;
          }
          await _requestData(pageNumber: _pageNumber + 1);
          _controller.loadComplete();
        },
        child: _buildContents(state: state),
      );

  ///
  /// 渲染内容区
  Widget _buildContents({AppState state}) {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      /// 有一种情况，如果没有提供category,且keyword为空的时候,不要默认加载骨架屏
      /// 因为这种时候，用户其实在调用搜索来渲染组件
      if (widget.category == null &&
          (widget.keyword == null || widget.keyword == "")) {
        return const Center(
          child: const DiscuzText('输入关键字来搜索'),
        );
      }

      return const DiscuzSkeleton(
        isCircularImage: false,
        isBottomLinesActive: true,
      );
    }

    if (_threadsCacher.threads.length == 0 && !_loading) {
      return const DiscuzNoMoreData();
    }

    ///
    /// 为了保证scroll 滑动流畅，这里不要使用Listview，不然总有些奇奇怪怪的问题
    /// Listview.builder可以仅构建屏幕内的Item，而不是构建整个listview tree
    return ListView.builder(
        controller: _scrollController,
        itemCount: _threadsCacher.threads.length,
        itemBuilder: (BuildContext context, index) => ThreadCard(
              threadsCacher: _threadsCacher,
              thread: _threadsCacher.threads[index],
            ));
  }

  ///
  /// _requestData will get data from backend
  Future<void> _requestData({int pageNumber, String keyword}) async {
    ///
    /// 如果是第一页的时候要先清空数据，防止数据重复
    if (pageNumber == 1) {
      _continueToRead = false;
      _threadsCacher.clear();
    }

    ///
    /// 正在加载
    ///
    setState(() {
      _loading = true;
    });

    List<String> includes = [
      RequestIncludes.user,
      RequestIncludes.firstPost,
      RequestIncludes.firstPostLikedUsers,
      RequestIncludes.firstPostImages,
      RequestIncludes.lastThreePosts,
      RequestIncludes.lastThreePostsUser,
      RequestIncludes.lastThreePostsReplyUser,
      RequestIncludes.threadVideo,
      RequestIncludes.rewardedUsers
    ];

    Map<String, dynamic> filters = {};
    widget.filter.filter.forEach((element) => filters
        .addAll({"filter[${element.keys.first}]": element.values.first}));

    dynamic data = {
      "page[limit]": Global.requestPageLimit,
      "page[number]": pageNumber ?? _pageNumber,
      "include": RequestIncludes.toGetRequestQueries(includes: includes),

      /// ext filters
      ...filters
    };

    /// 有的时候widget.category并不会传入，如查询帖子列表的时候
    /// 这种时候不需要提供categoryId
    if (widget.category != null) {
      data.addAll({"filter[categoryId]": widget.category.id});
    }

    /// 查询列表的时候，有时候用户会提供keyword来查询，这个时候要增加filter查询条件
    if (widget.keyword != null && widget.keyword != '') {
      data.addAll({"filter[q]": widget.keyword});
    }

    Response resp = await Request(context: context)
        .getUrl(url: Urls.threads, queryParameters: data);
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
    /// 数据更新后 ThreadsCacher.builder 会根据最新的数据来���构Widget tree便会展示最新数据
    final List<dynamic> threads = resp.data['data'] ?? [];
    final List<dynamic> included = resp.data['included'] ?? [];

    /// 关联的数据，包含user, post，attachments 需要在缓存前进行转义
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
      _continueToRead = true;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;

      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
    });
  }
}
