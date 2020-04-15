import 'package:dio/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/requestIncludes.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzNetworkError.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/views/gallery/discuzGalleryDelegate.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';
import 'package:discuzq/widgets/posts/postDetBot.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';
import 'package:discuzq/widgets/threads/threadsCacher.dart';
import 'package:discuzq/widgets/threads/parts/threadFavoritesAndRewards.dart';
import 'package:discuzq/widgets/threads/parts/threadHeaderCard.dart';
import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/posts/postFloorCard.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/threads/parts/threadExtendBottomBar.dart';
import 'package:discuzq/widgets/common/discuzImage.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/threads/parts/threadVideoSnapshot.dart';

class ThreadDetailDelegate extends StatefulWidget {
  ///
  /// 要显示的主题
  ///
  final ThreadModel thread;

  ///
  /// 作者
  ///
  final UserModel author;

  const ThreadDetailDelegate(
      {Key key, @required this.thread, @required this.author})
      : super(key: key);
  @override
  _ThreadDetailDelegateState createState() => _ThreadDetailDelegateState();
}

class _ThreadDetailDelegateState extends State<ThreadDetailDelegate> {
  ///
  /// _controller refresh
  ///
  final RefreshController _controller = RefreshController();

  ///------------------------------
  /// _threadsCacher 是用于缓存当前页面的主题数据的对象
  /// 当数据更新的时候，数据会存储到 _threadsCacher
  /// _threadsCacher 在页面销毁的时候，务必清空 .clear()
  ///
  final ThreadsCacher _threadsCacher = ThreadsCacher(singleton: false);

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
  /// 是否是连续加载
  bool _continueToRead = false;

  ///
  /// PostModel
  /// 首个评论
  PostModel _firstPost = const PostModel();

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

    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
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
              title: '详情',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: Stack(
              children: <Widget>[
                ///
                /// 内容
                ///
                Container(
                  child: !_continueToRead && _loading

                      /// 加载第一页时加载Loading 骨架屏
                      ? const DiscuzSkeleton(
                          length: Global.requestPageLimit,
                        )
                      : DiscuzRefresh(
                          controller: _controller,
                          enablePullDown: true,
                          enablePullUp: _enablePullUp,
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
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              /// 显示内容
                              _buildThreadContent(),

                              /// 显示评论
                              _buildComments(),
                            ],
                          ),
                        ),
                ),

                ///
                /// 底部点赞 回复 打赏工具栏
                _positionedBottomBar(),
              ],
            ),
          ));

  ///
  /// 渲染内容
  /// 此处的内容指的是帖子的内容
  Widget _buildThreadContent() {
    if (_threadsCacher.threads.length == 0 && !_loading) {
      return DiscuzNetworkError(
        onRequestRefresh: () => _requestData(),
      );
    }

    if (_threadsCacher.threads.length == 0) {
      return SizedBox();
    }

    /// 遍历图片
    final List<dynamic> getPostImages = _firstPost.relationships.images;
    List<AttachmentsModel> attachmentsModels = [];
    if (getPostImages.length > 0) {
      getPostImages.forEach((e) {
        final int id = int.tryParse(e['id']);
        final AttachmentsModel attachment = _threadsCacher.attachments
            .where((AttachmentsModel find) => find.id == id)
            .toList()[0];
        if (attachment != null) {
          attachmentsModels.add(attachment);
        }
      });
    }

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /// 顶部
          ThreadHeaderCard(
            author: widget.author,
            thread: widget.thread,
            showOperations: false,
          ),

          /// 显示标题
          ..._buildContentTitle(),

          /// 显示内容
          HtmlRender(
            html: _firstPost.attributes.contentHtml,
          ),

          /// 显示附件图片
          /// 显示图片
          /// 点击图片显示图集
          ...attachmentsModels
              .map((AttachmentsModel a) => Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: DiscuzImage(
                        attachment: a,
                        enbleShare: true,
                        isThumb: false,
                        thread: widget.thread,
                        onWantOriginalImage: (String targetUrl) {
                          /// 显示原图图集
                          /// targetUrl是用户点击到的要查看的图片
                          /// 调整数组，将targetUrl置于第一个，然后传入图集组件
                          ///
                          /// 原图所有图片Url 图集
                          final List<String> originalImageUrls =
                              attachmentsModels
                                  .map((e) => e.attributes.url)
                                  .toList();

                          /// 显示原图图集
                          /// targetUrl是用户点击到的要查看的图片
                          /// 调整数组，将targetUrl置于第一个，然后传入图集组件
                          originalImageUrls.remove(a.attributes.url);
                          originalImageUrls.insert(0, a.attributes.url);
                          return showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DiscuzGalleryDelegate(
                                      gallery: originalImageUrls));
                        }),
                  ))
              .toList(),

          ///
          /// 用于渲染小视频
          ///
          widget.thread.relationships.threadVideo == null
              ? const SizedBox()
              : ThreadVideoSnapshot(
                  threadsCacher: _threadsCacher,
                  thread: widget.thread,
                  post: _firstPost,
                ),

          /// 显示帖子 评论 收藏 分享等
          PostDetBot(
            thread: _threadsCacher.threads[0],

            ///注意： 要传入的thread 不应该是widget.thread，而是接口请求详情获取的主题
          )
        ],
      ),
    );
  }

  ///
  /// 渲染评论列表等
  Widget _buildComments() {
    if (_firstPost.id == 0) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 100),
      padding: const EdgeInsets.only(bottom: 10),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //const SizedBox(height: 20),

          /// 显示点赞
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ThreadFavoritesAndRewards(
              firstPost: _firstPost,
              threadsCacher: _threadsCacher,
              thread: widget.thread,
            ),
          ),

          ///
          /// 显示评论和用户
          /// 为什么 length= 1 的时候显示 DiscuzNoMoreData？
          /// 因为每个thread至少包含一个post，也就是首贴
          ///
          _threadsCacher.posts.length == 1
              ? const DiscuzNoMoreData()
              : _comments()
        ],
      ),
    );
  }

  ///
  /// 渲染评论
  ///
  Widget _comments() => Column(
        children: _threadsCacher.posts
            .map<Widget>((PostModel p) => Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: PostFloorCard(
                      post: p,
                      threadsCacher: _threadsCacher,
                      thread: widget.thread,
                      onDelete: () {
                        setState(() {
                          _threadsCacher.removePostByID(postID: p.id);
                        });
                      }),
                ))
            .toList(),
      );

  ///
  /// 底部工具栏
  Widget _positionedBottomBar() => Positioned(
        bottom: 0,
        child: ThreadExtendBottomBar(
          thread: widget.thread,
          firstPost: _firstPost,
          threadsCacher: _threadsCacher,
          onLikeTap: (bool liked) {
            print(liked);

            /// 如果我本次是点赞，那么就在用户列表增加我的名字
            ///
            /// 本次操作的是取消点赞那么就在点赞列表中移除我，
            ///
          },
        ),
      );

  /// 显示主题的标题
  /// 并不是所有主题都有标题，所以要做判断
  List<Widget> _buildContentTitle() => widget.thread.attributes.title == ""
      ? <Widget>[]
      : <Widget>[
          const SizedBox(height: 20),
          DiscuzText(
            widget.thread.attributes.title,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          const SizedBox(height: 5),
          const DiscuzDivider(
            padding: 0,
          ),
          const SizedBox(height: 5),
        ];

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
      RequestIncludes.postReplyUser,
      RequestIncludes.user,
      RequestIncludes.posts,
      RequestIncludes.postsUser,
      RequestIncludes.postslikedUsers,
      RequestIncludes.postsImages,
      RequestIncludes.firstPost,
      RequestIncludes.firstPostLikedUsers,
      RequestIncludes.firstPostImages,
      RequestIncludes.firstPostAttachments,
      RequestIncludes.rewardedUsers,
      RequestIncludes.category,
      RequestIncludes.threadVideo
    ];

    dynamic data = {
      "page[limit]": Global.requestPageLimit,
      "page[number]": pageNumber ?? _pageNumber,
      "include": RequestIncludes.toGetRequestQueries(includes: includes),
      "filter[isDeleted]": "no",
    };

    Response resp = await Request(context: context).getUrl(
        url: "${Urls.threads}/${widget.thread.id.toString()}",
        queryParameters: data);
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
    final List<dynamic> included = resp.data['included'] ?? [];

    /// 关联的数据，包含user, post，attachments 需要在缓存前进行转义
    try {
      final List<dynamic> threads =
          resp.data == null || resp.data['data'] == null
              ? []
              : [resp.data['data']];

      await _threadsCacher.computeThreads(threads: threads);
      await _threadsCacher.computeUsers(include: included);
      await _threadsCacher.computePosts(include: included);
      await _threadsCacher.computeAttachements(include: included);
      await _threadsCacher.computeThreadVideos(include: included);
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
      _continueToRead = true;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;

      ///
      /// 选出首贴
      _firstPost = _threadsCacher.posts
              .where((PostModel it) =>
                  it.id ==
                  int.tryParse(
                      widget.thread.relationships.firstPost['data']['id']))
              .toList()[0] ??
          PostModel();

      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
      _refreshEnablePullUp();
    });
  }
}
