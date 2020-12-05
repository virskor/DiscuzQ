import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:core/router/route.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/utils/authHelper.dart';
import 'package:core/widgets/users/yetNotLogon.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/views/users/profileDelegate.dart';
import 'package:core/views/users/myCollectionDelegate.dart';
import 'package:core/views/users/follows/followingDelegate.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/widgets/common/discuzDialog.dart';
import 'package:core/utils/global.dart';
import 'package:core/views/users/blackListDelegate.dart';
import 'package:core/widgets/share/shareApp.dart';
import 'package:core/widgets/users/userAccountBanner.dart';
import 'package:core/router/routers.dart';
import 'package:core/providers/userProvider.dart';

class AccountDelegate extends StatefulWidget {
  const AccountDelegate({Key key}) : super(key: key);
  @override
  _AccountDelegateState createState() => _AccountDelegateState();
}

class _AccountDelegateState extends State<AccountDelegate> {
  final RefreshController _controller = RefreshController();

  final List<_AccountMenuItem> _menus = [
    const _AccountMenuItem(
        label: '我的资料',
        icon: CupertinoIcons.wand_stars,
        child: const ProfileDelegate()),
    // const _AccountMenuItem(
    //     label: '我的钱包',
    //     icon: CupertinoIcons.money_yen_circle,
    //     child: const WalletDelegate()),
    const _AccountMenuItem(
        label: '我的收藏', icon: 0xe699, child: const MyCollectionDelegate()),
    const _AccountMenuItem(
        label: '我的关注', icon: 0xe680, child: const FollowingDelegate()),
    const _AccountMenuItem(
        label: '黑名单', icon: 0xe6d2, child: const BlackListDelegate()),

    /// 请求退出账户
    _AccountMenuItem(
        label: '退出登录',
        showDivider: false,
        method: ({BuildContext context}) =>
            DiscuzDialog.confirm(
                context: context,
                title: '提示',
                message: '是否退出登录？',
                onConfirm: () => AuthHelper.logout(context: context)),
        icon: 0xe6d0),
  ];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider user, Widget child) => Scaffold(
                appBar: DiscuzAppBar(
                  title: '个人中心',
                  brightness: Brightness.light,
                  actions: <Widget>[
                    const _ShareAppButton(),
                    const _SettingButton()
                  ],
                  backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
                ),
                body: user.user == null
                    ? const YetNotLogon()
                    : DiscuzRefresh(
                        controller: _controller,
                        enablePullDown: true,
                        onRefresh: () async {
                          await AuthHelper.refreshUser(
                              context: context);
                          _controller.refreshCompleted();
                        },
                        child: ListView(
                          children: <Widget>[
                            /// 构造登录信息页
                            const UserAccountBanner(),

                            /// 菜单构造

                            Container(
                              child: Wrap(
                                children: _buildMenus(),
                              ),
                            )
                          ],
                        ),
                      ),
              ));

  ///
  /// 生成个人中心滑动菜单
  ///
  List<Widget> _buildMenus() => _menus
      .map((el) => Container(
            decoration: BoxDecoration(
                border: const Border(bottom: Global.border),
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Column(
              children: <Widget>[
                DiscuzListTile(
                  title: DiscuzText(el.label),
                  leading: DiscuzIcon(el.icon),

                  /// 如果item中设置了运行相关的方法，则运行相关的方法，如果有child的话则在路由中打开
                  onTap: () => el.method != null
                      ? el.method(context: context)
                      : el.child == null
                          ? DiscuzToast.failed(
                              context: context, message: '暂时不支持')
                          : DiscuzRoute.navigate(
                              context: context, widget: el.child),
                ),
              ],
            ),
          ))
      .toList();
}

///
/// 设置按钮
class _SettingButton extends StatelessWidget {
  const _SettingButton();

  @override
  Widget build(BuildContext context) => IconButton(
        icon: DiscuzIcon(CupertinoIcons.gear_alt,
            color: DiscuzApp.themeOf(context).textColor),
        onPressed: () => DiscuzRoute.navigate(
          context: context,
          fullscreenDialog: true,
          path: Routers.preferences,
        ),
      );
}

///
/// 分享APP按钮
class _ShareAppButton extends StatelessWidget {
  const _ShareAppButton();

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider user, Widget child) => IconButton(
            icon: DiscuzIcon(CupertinoIcons.square_arrow_up,
                color: DiscuzApp.themeOf(context).textColor),
            onPressed: () => ShareApp.show(context: context, user: user.user),
          ));
}

/// 菜单列表
class _AccountMenuItem {
  /// 标签
  final String label;

  /// 路由跳转
  final Widget child;

  /// 图标
  final dynamic icon;

  /// 函数
  final Function method;

  /// 显示分割线
  final bool showDivider;

  const _AccountMenuItem(
      {@required this.label,
      @required this.icon,
      this.method,
      this.showDivider = true,
      this.child});
}
