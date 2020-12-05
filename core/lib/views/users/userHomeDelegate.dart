import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/models/userModel.dart';
import 'package:core/widgets/common/discuzNomoreData.dart';
import 'package:core/widgets/users/userRecentThreads.dart';
import 'package:core/models/userGroupModel.dart';
import 'package:core/api/users.dart';
import 'package:core/router/route.dart';
import 'package:core/views/reports/reportsDelegate.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/api/blackList.dart';
import 'package:core/widgets/common/discuzDialog.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/providers/userProvider.dart';

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
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      if (!widget.forceToUpdate) {
        return;
      }
      _requestUserData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider user, Widget child) =>
          Scaffold(
            appBar: DiscuzAppBar(
              title: _getTitle(),
              actions: <Widget>[
                ///
                /// 举报按钮仅在查看其它用户时显示
                user.user != null && user.user.id != widget.user.id
                    ? _normalPopMenu()
                    : const SizedBox()
              ],
              brightness: Brightness.light,
            ),
            body: _buildBody(context: context),
          ));

  Widget _normalPopMenu() => Theme(
        data: Theme.of(context).copyWith(
          cardColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
        ),
        child: PopupMenuButton<String>(
            icon: DiscuzIcon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      value: 'report', child: const DiscuzText('举报')),
                  PopupMenuItem<String>(
                      value: 'blackList', child: const DiscuzText('拉黑'))
                ],
            onSelected: (String value) {
              if (value == 'report') {
                DiscuzRoute.navigate(
                  context: context,
                  shouldLogin: true,
                  fullscreenDialog: true,
                  widget: Builder(
                    builder: (context) =>
                        ReportsDelegate(type: ReportType.homepage, user: _user),
                  ),
                );
                return;
              }

              DiscuzDialog.confirm(
                  context: context,
                  title: '拉黑用户',
                  message: '您确定拉黑该用户吗?',
                  onConfirm: () async {
                    final bool result =
                        await BlackListAPI(context: context).add(uid: _user.id);
                    if (result && Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  });

              /// add user into black list
            }),
      );

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
