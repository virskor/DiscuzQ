import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/api/blackList.dart';
import 'package:core/models/metaModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/widgets/common/discuzAvatar.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/widgets/skeleton/discuzSkeleton.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/providers/userProvider.dart';

class BlackListDelegate extends StatefulWidget {
  const BlackListDelegate({Key key}) : super(key: key);
  @override
  _BlackListDelegateState createState() => _BlackListDelegateState();
}

class _BlackListDelegateState extends State<BlackListDelegate> {
  /*
   * 当前的分页 
   */
  int _pageNumber = 1;

  /*
   *  _controller refresh
   */
  final RefreshController _controller = RefreshController();

  /*
   * 用户列表 
   */
  List<UserModel> _denyUsers = [];

  /*
   * meta required threadCount && pageCount
   */
  MetaModel _meta;

  /*
   * 是否正在加载 
   */
  bool _loading = true;

  /*
   * 是否为连续加载
   */
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
    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider user, Widget child) =>
          Scaffold(
            appBar: DiscuzAppBar(
              title: _title,
              brightness: Brightness.light,
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _buildBody(),
          ));

  ///
  /// 是否允许加载更多
  bool get _enablePullUp => _meta == null
      ? false
      : _meta.pageCount > _pageNumber
          ? true
          : false;

  ///
  /// 是否允许加载更多
  String get _title => _meta == null ? "黑名单" : "黑名单(${_meta.total})";

  /*
   * Body Widget 
   */
  Widget _buildBody() {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      return const DiscuzSkeleton(
        isCircularImage: false,
        isBottomLinesActive: false,
      );
    }

    if (_denyUsers.length == 0) {
      return const Center(child: const DiscuzText('暂无黑名单记录'));
    }

    return DiscuzRefresh(
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
        children: _denyUsers
            .map((u) => DiscuzListTile(
                  leading: DiscuzAvatar(
                    url: u.attributes.avatarUrl,
                    size: 45,
                  ),
                  title: DiscuzText(
                    u.attributes.username,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: DiscuzLink(
                    label: '移除',
                    onTap: () async => await _remove(u),
                  ),
                ))
            .toList(),
      ),
    );
  }

  /*
   * 删除用户 
   */
  Future<void> _remove(UserModel u) async {
    try {
      await BlackListAPI(context: context).delete(uid: u.id);
    } catch (e) {
      print(e);
    }

    setState(() {
      _denyUsers.remove(u);
    });
  }

  /*
   * 获取屏蔽的用户列表
   */
  Future<void> _requestData({int pageNumber}) async {
    if (pageNumber == 1) {
      _continueToRead = false;
      _denyUsers.clear();
    }

    setState(() {
      _loading = true;
    });

    try {
      final Response resp = await BlackListAPI(context: context)
          .list(uid: context.read<UserProvider>().user.id, pageNumber: pageNumber ?? 1);

      final List<dynamic> data = resp.data['data'] ?? [];
      final List<UserModel> users =
          data.map((e) => UserModel.fromMap(maps: e)).toList();

      setState(() {
        _loading = false;
        _continueToRead = true;
        _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
        _denyUsers.addAll(users);

        /// pageNumber 在onload传入时已经自动加1
        _meta = MetaModel.fromMap(maps: resp.data['meta']);
      });
    } catch (e) {
      throw e;
    }
  }
}
