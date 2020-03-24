import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/users/userFollowRequest.dart';

///
/// 关注用户
///
class UserFollow extends StatefulWidget {
  ///要关注的用户
  final UserModel user;

  const UserFollow({this.user});

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
  String _followButtonLabel() => _user.follow == 1 ? "取消关注" : "关注TA";

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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) =>
          _buildBody(context: context, state: state));

  ///
  /// build body
  Widget _buildBody({BuildContext context, AppState state}) {
    if (_loading) {
      return DiscuzIndicator();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: state.user == null
          ? <Widget>[]

          /// 用户未登录 不显示组件

          /// 查看的是自己 的账户，不显示关注按钮
          : <Widget>[
              DiscuzText(
                '关注：${widget.user.followCount.toString()}',
                color: DiscuzApp.themeOf(context).greyTextColor,
              ),
              const SizedBox(width: 10),
              DiscuzText(
                '|',
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              DiscuzText(
                '被关注：${_user.fansCount.toString()}',
                color: DiscuzApp.themeOf(context).greyTextColor,
              ),
              state.user.id == widget.user.id
                  ? const SizedBox()
                  : Row(
                      children: <Widget>[
                        const SizedBox(width: 10),
                        DiscuzLink(
                          label: _followButtonLabel(),

                          /// 动态文案
                          onTap: _requestFollow,
                        )
                      ],
                    )
            ],
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
      _user = UserModel.fromMap(maps: resp.data['data']['attributes']);
    });
  }

  ///
  /// request follow
  /// 如果用户请求取消关注，应该发送delete请求，如果是关注则，直接发送post请求
  /// 关注
  Future<void> _requestFollow({BuildContext context}) async {
    final bool requetFollow =
        await UserFollowRequest.requestFollow(context: context, user: _user);

    /// 请求时失败的，不更新UI
    if (!requetFollow) {
      return;
    }

    setState(() {
      ///
      /// 更新当前查看的用户信息
      _user = UserModel.copyWith(
          userModel: _user,
          follow: _user.follow == 0 ? 1 : 0,
          fansCount:
              _user.follow == 0 ? _user.fansCount + 1 : _user.fansCount - 1);
    });
  }
}
