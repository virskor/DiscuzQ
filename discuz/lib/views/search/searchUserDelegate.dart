import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/widgets/appbar/searchAppbar.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';
import 'package:discuzq/widgets/users/userListTile.dart';

///
/// 搜索用户
///
class SearchUserDelegate extends StatefulWidget {
  const SearchUserDelegate();

  @override
  _SearchUserDelegateState createState() => _SearchUserDelegateState();
}

class _SearchUserDelegateState extends State<SearchUserDelegate> {
  /// refresh controller
  final RefreshController _controller = RefreshController();

  ///
  /// states
  ///
  String _keyword;

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
  /// _enablePullUp
  /// 是否允许加载更多
  bool _enablePullUp = false;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _users.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppbar(
        placeholder: '输入关键字搜索用户',
        onSubmit: (String keyword, bool shouldShowNoticeEmpty) async {
          if (shouldShowNoticeEmpty && keyword == "") {
            DiscuzToast.failed(context: context, message: '缺少关键字');
            return;
          }
          setState(() {
            _keyword = keyword;
          });

          await _requestData(context: context, pageNumber: 1);
        },
      ),
      backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  ///
  /// 是否允许加载更多页面
  ///
  void _refreshEnablePullUp() {
    final bool enabled =
        _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;
    _enablePullUp = enabled;
  }

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
        length: Global.requestPageLimit,
        isBottomLinesActive: false,
      );
    }

    if (_users.length == 0) {
      return const DiscuzNoMoreData();
    }

    return ListView(
      children: _users.map((UserModel u) {
        return UserListTile(user: u);
      }).toList(),
    );
  }

  ///
  /// 请求用户搜索结果
  Future<void> _requestData({BuildContext context, int pageNumber}) async {
    if(_loading){
      return;
    }

    if(pageNumber == 1){
      _users.clear(); /// 要清空历史搜索数据，否则会重复渲染到UI
      setState(() {
        _continueToRead = false;
      });
    }

    final dynamic data = {
      'filter[username]': '*$_keyword*',
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
      print(e);
    }

    print({_users.length, resp.data['data'].length});

    setState(() {
      _loading = false;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
      _continueToRead = true;
      _users.addAll([...userModels]);
      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
      _refreshEnablePullUp();
    });
  }
}
