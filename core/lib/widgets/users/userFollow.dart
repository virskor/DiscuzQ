import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/models/userModel.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzIndicater.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/api/users.dart';
import 'package:core/providers/userProvider.dart';

///
/// 关注用户
///
class UserFollow extends StatefulWidget {
  /// 要关注的用户
  final UserModel user;

  /// 要关注的用户数据发生变化的回调
  ///
  final Function onUserChanged;

  const UserFollow({this.user, this.onUserChanged});

  @override
  _UserFollowState createState() => _UserFollowState();
}

class _UserFollowState extends State<UserFollow> {
  /// states
  /// 从远端获取当前查看的用户，可查询是否我已经关注他
  /// 默认数据为空，将在接口请求后，进行覆盖处理
  UserModel _user = UserModel();

  /// _loading
  bool _loading = true;

  ///
  /// 关注按钮的文案
  /// 根据实际情况来显示关注按钮的文案，如果已经关注了，则显示取消否则关注
  ///
  String _followButtonLabel() => _user.attributes.follow == 1 ? "取消关注" : "关注TA";

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
    /// 获取最新的要查看的用户信息
    Future.delayed(Duration.zero).then((_) async => await _requestUserData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider user, Widget child) =>
          _buildBody(context: context, user: user.user));

  ///
  /// build body
  Widget _buildBody({BuildContext context, UserModel user}) {
    if (_loading) {
      return DiscuzIndicator();
    }

    return user.attributes.id == widget.user.id
        ? const SizedBox()
        : SizedBox(
            width: 90,
            height: 35,
            child: DiscuzButton(
              label: _followButtonLabel(),

              /// 动态文案
              onPressed: () => _requestFollow(context: context),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          );
  }

  ///
  /// 获取当前查询用户的关注信息
  ///
  Future<void> _requestUserData() async {
    ///
    /// 减少UI render
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }

    Response resp = await Request(context: context)
        .getUrl(url: "${Urls.users}/${widget.user.id}");
    if (resp == null) {
      setState(() {
        _loading = false;
      });
      DiscuzToast.failed(context: context, message: '获取用户失败');
      return Future.value(false);
    }

    /// 更新查看的用户信息
    setState(() {
      _loading = false;
      _user = UserModel.fromMap(maps: resp.data['data']);
    });
  }

  ///
  /// request follow
  /// 如果用户请求取消关注，应该发送delete请求，如果是关注则，直接发送post请求
  /// 关注
  Future<void> _requestFollow({BuildContext context}) async {
    final bool requetFollow = await UsersAPI.requestFollow(
        context: context,
        user: _user,
        isUnfollow: _user.attributes.follow == 1);

    /// 请求时失败的，不更新UI
    if (!requetFollow) {
      return;
    }

    setState(() {
      ///
      /// 更新当前查看的用户信息
      _user = UserModel.copyWith(
          userModel: _user,
          follow: _user.attributes.follow == 0 ? 1 : 0,
          fansCount: _user.attributes.follow == 0
              ? _user.attributes.fansCount + 1
              : _user.attributes.fansCount - 1);
    });

    if (widget.onUserChanged != null) {
      widget.onUserChanged(_user);
    }
  }
}
