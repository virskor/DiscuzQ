import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/nightModeSwitcher.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/users/yetNotLogon.dart';
import 'package:discuzq/views/settings/preferencesDelegate.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/views/users/profileDelegate.dart';
import 'package:discuzq/views/users/walletDelegate.dart';
import 'package:discuzq/views/users/myCollectionDelegate.dart';
import 'package:discuzq/views/users/follows/followingDelegate.dart';
import 'package:discuzq/widgets/share/shareApp.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/common/discuzDialog.dart';

import '../widgets/common/discuzText.dart';
import '../widgets/ui/ui.dart';

class AccountDelegate extends StatefulWidget {
  const AccountDelegate({Key key}) : super(key: key);
  @override
  _AccountDelegateState createState() => _AccountDelegateState();
}

class _AccountDelegateState extends State<AccountDelegate> {
  final RefreshController _controller = RefreshController();

  final List<_AccountMenuItem> _menus = [
    const _AccountMenuItem(
        label: '偏好设置',
        icon: SFSymbols.gear,
        separate: true,
        showDivider: false,
        child: const PreferencesDelegate()),
    const _AccountMenuItem(
        label: '我的资料',
        icon: SFSymbols.wand_stars,
        separate: true,
        child: const ProfileDelegate()),
    const _AccountMenuItem(
        label: '我的钱包',
        icon: SFSymbols.money_yen_circle,
        child: const WalletDelegate()),
    const _AccountMenuItem(
        label: '我的收藏',
        icon: SFSymbols.star,
        child: const MyCollectionDelegate()),
    const _AccountMenuItem(
        label: '我的关注',
        icon: SFSymbols.lasso,
        showDivider: false,
        child: const FollowingDelegate()),
    // const _AccountMenuItem(
    //     label: '黑名单',
    //     icon: SFSymbols.captions_bubble_fill,
    //     showDivider: false,
    //     separate: true,
    //     child: const BlackListDelegate()),

    /// 请求退出账户
    _AccountMenuItem(
        label: '退出登录',
        showDivider: false,
        method: (AppState state, {BuildContext context}) =>
            DiscuzDialog.confirm(
                context: context,
                title: '提示',
                message: '是否退出登录？',
                onConfirm: () => AuthHelper.logout(state: state)),
        icon: SFSymbols.arrow_right_square),
    _AccountMenuItem(
        label: '邀请朋友',
        icon: SFSymbols.square_arrow_up,
        method: (AppState state, {BuildContext context}) =>
            ShareApp.show(context: context, user: state.user),
        showDivider: false,
        separate: true),
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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '个人中心',
              elevation: 0,
              actions: <Widget>[const NightModeSwitcher()],
            ),
            body: state.user == null
                ? const YetNotLogon()
                : DiscuzRefresh(
                    controller: _controller,
                    enablePullDown: true,
                    onRefresh: () async {
                      await AuthHelper.refreshUser(
                          context: context, state: state);
                      _controller.refreshCompleted();
                    },
                    child: ListView(
                      children: <Widget>[
                        /// 构造登录信息页
                        const _MyAccountCard(),

                        /// 菜单构造
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            children: _buildMenus(state),
                          ),
                        )
                      ],
                    ),
                  ),
          ));

  ///
  /// 生成个人中心滑动菜单
  ///
  List<Widget> _buildMenus(AppState state) => _menus
      .map((el) => Container(
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Column(
              children: <Widget>[
                DiscuzListTile(
                  title: DiscuzText(el.label),
                  leading: DiscuzIcon(el.icon),

                  /// 如果item中设置了运行相关的方法，则运行相关的方法，如果有child的话则在路由中打开
                  onTap: () => el.method != null
                      ? el.method(state, context: context)
                      : el.child == null
                          ? DiscuzToast.failed(
                              context: context, message: '暂时不支持')
                          : DiscuzRoute.open(
                              context: context, widget: el.child),
                ),
                el.showDivider == true
                    ? const DiscuzDivider()
                    : const SizedBox()
              ],
            ),
          ))
      .toList();
}

/// 菜单列表
class _AccountMenuItem {
  /// 标签
  final String label;

  /// 路由跳转
  final Widget child;

  /// 是否添加分割
  final bool separate;

  /// 图标
  final IconData icon;

  /// 函数
  final Function method;

  /// 显示分割线
  final bool showDivider;

  const _AccountMenuItem(
      {@required this.label,
      @required this.icon,
      this.separate = false,
      this.method,
      this.showDivider = true,
      this.child});
}

/// 我的账号头部信息
class _MyAccountCard extends StatelessWidget {
  const _MyAccountCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: DiscuzListTile(
              leading: Hero(
                tag: 'heroAvatar',
                child: DiscuzAvatar(
                  size: 55,
                ),
              ),
              title: DiscuzText(
                state.user.attributes.username ?? '',
                fontSize: DiscuzApp.themeOf(context).largeTextSize,
              ),
              subtitle: DiscuzText(
                '查看个人主页',
                fontWeight: FontWeight.w300,
                color: DiscuzApp.themeOf(context).greyTextColor,
              ),

              /// todo: 增加bio显示，待��口反馈
              onTap: () => DiscuzRoute.open(
                  context: context,
                  shouldLogin: true,
                  widget: UserHomeDelegate(
                    user: state.user,
                  )),
            ),
          ));
}
