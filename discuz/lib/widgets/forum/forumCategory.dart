import 'package:dio/dio.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/widgets/forum/forumCategoryFilter.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncluedes.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/threads/ThreadCard.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';

///
/// 注意：
/// 当filter传入的属性变化时，组件会异步重载，
/// 重载指的是完全从头开始重新筛选，因为此时用户修改了筛选条件
/// 页面下拉则会从头刷新
/// load 上拉则会加载下一页的数据
///
///
///

class ForumCategory extends StatefulWidget {
  /// 要显示的分类
  final CategoryModel category;

  ///
  /// onAppbarState
  final Function onAppbarState;

  /// 用户查询的筛选条件
  final ForumCategoryFilterItem filter;

  ForumCategory(this.category,
      {Key key, this.onAppbarState, @required this.filter})
      : super(key: key);

  @override
  _ForumCategoryState createState() => _ForumCategoryState();
}

class _ForumCategoryState extends State<ForumCategory> {
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

    ///
    /// 绑定列表移动时间观察
    this._watchScrollOffset();

    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _requestData(pageNumber: 1));
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
      final bool wantHide = _scrollController.offset > 300 ? false : true;

      if (widget.onAppbarState != null && wantHide != showAppbar) {
        widget.onAppbarState(wantHide);
        showAppbar = wantHide;
      }
    });
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
      builder: (context, child, state) => RepaintBoundary(
            child: _body(context: context, state: state),
          ));

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

  Widget _buildContents({AppState state}) {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      return const DiscuzSkeleton(
        isCircularImage: false,
        length: Global.requestPageLimit,
        isBottomLinesActive: true,
      );
    }

    if (_threadsCacher.threads.length == 0 && !_loading) {
      return const DiscuzNoMoreData();
    }

    return ListView(
      controller: _scrollController,
      children: _buildCollectionsList(state: state),
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
    widget.filter.filter.forEach((element) {
      filters.addAll({"filter[${element.keys.first}]": element.values.first});
    });

    dynamic data = {
      "page[limit]": Global.requestPageLimit,
      "page[number]": pageNumber ?? _pageNumber,
      "include": RequestIncludes.toGetRequestQueries(includes: includes),
      "filter[categoryId]": widget.category.id,

      /// ext filters
      ...filters
    };

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
      _continueToRead = true;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
      _refreshEnablePullUp();
    });
  }
}
