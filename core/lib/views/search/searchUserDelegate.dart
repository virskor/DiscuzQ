import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:core/models/metaModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzNomoreData.dart';
import 'package:core/widgets/skeleton/discuzSkeleton.dart';
import 'package:core/widgets/users/userListTile.dart';
import 'package:core/widgets/ui/ui.dart';

///
/// 搜索用户
///
class SearchUserDelegate extends StatefulWidget {
  const SearchUserDelegate({this.keyword});

  final String keyword;

  @override
  _SearchUserDelegateState createState() => _SearchUserDelegateState();
}

class _SearchUserDelegateState extends State<SearchUserDelegate>
    with AutomaticKeepAliveClientMixin {
  /// refresh controller
  final RefreshController _controller = RefreshController();

  ///
  /// _pageNumber
  int _pageNumber = 1;

  ///
  /// users
  ///
  List<UserModel> _users = [];

  ///
  /// meta
  MetaModel _meta;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

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
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    _users.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchUserDelegate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget == null) {
      return;
    }

    ///
    /// 如果keyword 证明用户重新输入了关键字，那么久执行重新请求
    if (widget.keyword != null && oldWidget.keyword != widget.keyword) {
      Future.delayed(Duration(milliseconds: 450))
          .then((_) async => await _requestData(pageNumber: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
        color: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
        child: _buildBody(context));
  }

  ///
  /// 是否允许加载更多
  bool get _enablePullUp =>
      _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;

  ///
  /// 生成搜索用户的组件
  ///
  Widget _buildBody(BuildContext context) => DiscuzRefresh(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        onLoading: () async {
          if (_loading) {
            return;
          }
          await _requestData(pageNumber: _pageNumber + 1);
          _controller.loadComplete();
        },
        onRefresh: () async {
          await _requestData(pageNumber: 1);
          _controller.refreshCompleted();
        },
        child: _buildUsersList(),
      );

  ///
  /// 渲染查找到的用户列表
  Widget _buildUsersList() {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      return const DiscuzSkeleton(
        isCircularImage: false,
        isBottomLinesActive: false,
      );
    }

    if (_users.length == 0) {
      return const DiscuzNoMoreData();
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (BuildContext context, index) =>
          UserListTile(user: _users[index]),
    );
  }

  ///
  /// 请求用户搜索结果
  Future<void> _requestData({BuildContext context, int pageNumber}) async {
    if (_loading) {
      return;
    }

    if (pageNumber == 1) {
      _users.clear();

      /// 要清空历史搜索数据，否则会重复渲染到UI
      setState(() {
        _continueToRead = false;
      });
    }

    final dynamic data = {
      'filter[username]': '*${widget.keyword}*',
      "page[number]": pageNumber ?? _pageNumber,
      'page[limit]': Global.requestPageLimit
    };

    setState(() {
      _loading = true;
    });

    Response resp = await Request(context: context)
        .getUrl(url: Urls.users, queryParameters: data);
    setState(() {
      _loading = false;
    });
    final List<dynamic> users = resp.data['data'] ?? [];

    List<UserModel> userModels;

    try {
      ///
      /// 生成新的 _users
      /// 当底部的setState触发UI更新时，实际上 _users会重新渲染UI，所以这里不必要SetState 否则就脱裤子放屁了
      userModels = users
          .where((u) => u['type'] == 'users')
          .map((p) => UserModel.fromMap(maps: p))
          .toList();
    } catch (e) {
      throw e;
    }

    setState(() {
      _loading = false;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
      _continueToRead = true;
      _users.addAll([...userModels]);

      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
    });
  }
}
