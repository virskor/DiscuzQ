import 'package:discuzq/api/usersAPI.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/reports/reportsDelegate.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/users/userRecentThreads.dart';
import 'package:discuzq/models/userGroupModel.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class UserHomeDelegate extends StatefulWidget {
  const UserHomeDelegate(
      {Key key, @required this.user, this.forceToUpdate = true, this.userGroup})
      : super(key: key);

  /// Target User
  final UserModel user;

  /// Force to update
  /// 当传入的用户信息不完整时，需要使用forceUpdate来请求最新的用户数据
  final bool forceToUpdate;

  /// userGroup
  /// 非必要参数，当 !forceToUpdate 需要传入
  final UserGroupModel userGroup;

  @override
  _UserHomeDelegateState createState() => _UserHomeDelegateState();
}

class _UserHomeDelegateState extends State<UserHomeDelegate> {
  ///
  /// uniquekey
  ///
  final UniqueKey uniqueKey = UniqueKey();

  ///
  /// 使用用户信息的时候，不应该使用widget.user进行渲染
  /// 而应该使用_user
  /// 这是因为 widget.user不不包含完整的用户信息
  UserModel _user;

  ///
  /// 用户组信息
  /// 用户组信息将在requestUserData的时候更新
  UserGroupModel _userGroup;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }

    super.setState(fn);
  }

  @override
  void initState() {
    ///
    /// 在组件初始化前，先使用 widget.user 赋值到 _user
    /// 之后再异步更新 _user
    /// 记得，要在super.initState前进行这个操作
    _user = widget.user;
    _userGroup = widget.userGroup ?? const UserGroupModel();

    super.initState();

    ///
    /// 异步请求新的用户信息
    if (widget.forceToUpdate) {
      Future.delayed(Duration(milliseconds: 300))
          .then((_) => _requestUserData());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            key: uniqueKey,
            appBar: DiscuzAppBar(
              title: _getTitle(),
              actions: <Widget>[
                ///
                /// 举报按钮仅在查看其它用户时显示
                state.user != null && state.user.id != widget.user.id
                    ? IconButton(
                        icon: DiscuzIcon(
                          SFSymbols.flag,
                          color: Colors.white,
                        ),
                        onPressed: () => DiscuzRoute.open(
                          context: context,
                          shouldLogin: true,
                          fullscreenDialog: true,
                          widget: Builder(
                            builder: (context) => ReportsDelegate(
                                type: ReportType.thread, user: _user),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            body: _buildBody(context: context),
          ));

  ///
  /// Title
  String _getTitle() => _user.attributes.username == ''
      ? '这个人去火星了'
      : '${_user.attributes.username}的个人主页';

  Widget _buildBody({BuildContext context}) {
    if (_user.attributes.username == "") {
      return const Center(
        child: const DiscuzNoMoreData(),
      );
    }

    return UserRecentThreads(
      user: _user,
      userGroup: _userGroup,
    );
  }

  ///
  /// 异步的请求用户的信息，以覆盖现有的用户信息
  /// 同时更新用户组信息
  Future<void> _requestUserData() async {
    ///
    Map<UserModel, UserGroupModel> userInfo =
        await UsersAPI(context: context).getUserDataByID(uid: widget.user.id);

    if (userInfo == null) {
      return;
    }

    setState(() {
      _user = userInfo.keys.first;
      _userGroup = userInfo.values.first;
    });
  }
}
