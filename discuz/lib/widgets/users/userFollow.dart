import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

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
          : state.user.id == widget.user.id
              ? <Widget>[]

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
                  const SizedBox(width: 10),
                  DiscuzLink(
                    label: _followButtonLabel(),

                    /// 动态文案
                    onTap: _requestFollow,
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
  Future<void> _requestFollow() async {
    Response resp;

    ///
    /// 用于请求的数据
    final dynamic data = {
      "data": {
        "attributes": {
          "to_user_id": _user.id,
        }
      }
    };

    // final Function closeLoading = DiscuzToast.loading(context: context);
    final Function closeLoading = () => null;
    if (_user.follow == 1) {
      /// 取消关注
      /// 取消关注时，会返回204，DIO会默认处理成错误，所以要自己在处理下
      /// 如果后续DZ接口调整，也要直接返回
      try {
        resp = await Request(context: context)
            .delete(url: Urls.follow, data: data);
        closeLoading();
        setState(() {
          ///
          /// 更新当前查看的用户信息
          _user = UserModel.copyWith(
              userModel: _user, follow: 0, fansCount: _user.fansCount - 1);
        });
      } catch (e) {
        final DioError err = e;
        if (err.response.statusCode == 204) {
          DiscuzToast.success(context: context, message: '操作成功');
          return;
        }
      }
      DiscuzToast.success(context: context, message: '操作成功');
      return;
    }

    ///
    /// 请求关注某个用户
    ///
    resp =
        await Request(context: context).postJson(url: Urls.follow, data: data);
    closeLoading();
    if (resp == null) {
      DiscuzToast.failed(context: context, message: '操作失败');
      return;
    }

    setState(() {
      ///
      /// 更新当前查看的用户信息
      _user = UserModel.copyWith(
          userModel: _user, follow: 1, fansCount: _user.fansCount + 1);
    });
    DiscuzToast.success(context: context, message: '操作成功');
  }
}
