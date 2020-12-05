import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:core/widgets/forum/forumCategoryFilter.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/models/categoryModel.dart';
import 'package:core/models/metaModel.dart';
import 'package:core/utils/global.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/requestIncludes.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/threads/threadCard.dart';
import 'package:core/widgets/threads/threadsCacher.dart';
import 'package:core/widgets/skeleton/discuzSkeleton.dart';
import 'package:core/widgets/common/discuzNomoreData.dart';

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
  ThreadsList(
      {Key key,
      this.category,
      this.onAppbarState,
      @required this.filter,
      this.topicID,
      this.keyword})
      : super(key: key);

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

  /// 关联话题ID
  final int topicID;

  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ThreadsList>
    with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

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

    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }

    if (_scrollController != null) {
      _scrollController.dispose();
    }

    _threadsCacher.clear();

    /// 清空缓存的主题列表数据
    /// do not forget to dispose _controller
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
  Widget build(BuildContext context) {
    super.build(context);
    return _body();
  }

  /// build body
  Widget _body() => DiscuzRefresh(
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
        child: _buildContents(),
      );

  ///
  /// 渲染内容区
  Widget _buildContents() {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
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
        addAutomaticKeepAlives: true,
        itemBuilder: (BuildContext context, index) => ThreadCard(
              threadsCacher: _threadsCacher,
              thread: _threadsCacher.threads[index],
            ));
  }

  ///
  /// _requestData will get data from backend
  Future<void> _requestData({int pageNumber}) async {
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

    ///
    /// 关联话题
    if (widget.topicID != null) {
      filters.addAll({"filter[topicId]": widget.topicID});
    }

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
