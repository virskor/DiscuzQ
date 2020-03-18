import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/router/route.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/views/site/siteinfoDelegate.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/users/yetNotLogon.dart';
import 'package:discuzq/views/settings/preferencesDelegate.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

class AccountDelegate extends StatefulWidget {
  const AccountDelegate({Key key}) : super(key: key);
  @override
  _AccountDelegateState createState() => _AccountDelegateState();
}

class _AccountDelegateState extends State<AccountDelegate> {
  final List<_AccountMenuItem> _menus = [
    const _AccountMenuItem(
        label: '偏好设置',
        icon: SFSymbols.gear,
        separate: true,
        child: const PreferencesDelegate()),
    const _AccountMenuItem(
        label: '我的资料', icon: SFSymbols.wand_stars, separate: true),
    const _AccountMenuItem(label: '我的钱包', icon: SFSymbols.money_yen_circle),
    const _AccountMenuItem(label: '我的收藏', icon: SFSymbols.star),
    const _AccountMenuItem(label: '我的通知', icon: SFSymbols.bell),
    const _AccountMenuItem(label: '我的关注', icon: SFSymbols.lasso),
    const _AccountMenuItem(
        label: '黑名单', icon: SFSymbols.captions_bubble_fill, separate: true),
    const _AccountMenuItem(
        label: '站点信息',
        icon: SFSymbols.info_circle,
        separate: true,
        child: const SiteinfoDelegate()),

    /// 请求退出账户
    _AccountMenuItem(
        label: '退出登录',
        method: (AppModel model) => AuthHelper.logout(model: model),
        icon: SFSymbols.arrow_right_square),
    const _AccountMenuItem(
        label: '邀请朋友', icon: SFSymbols.square_arrow_up, separate: true),
  ];

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: true,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              title: '个人中心',
              elevation: 0,
            ),
            body: model.user == null
                ? const YetNotLogon()
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        /// 构造登录信息页
                        const _MyAccountCard(),

                        /// 菜单构造
                        ..._buildMenus(model)
                      ],
                    ),
                  ),
          ));

  List<Widget> _buildMenus(AppModel model) => _menus
      .map((el) => Container(
            margin: EdgeInsets.only(top: el.separate == true ? 20 : 0),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Column(
              children: <Widget>[
                DiscuzListTile(
                  title: DiscuzText(el.label),
                  leading: DiscuzIcon(el.icon),

                  /// 如果item中设置了运行相关的方法，则运行相关的方法，如果有child的话则在路由中打开
                  onTap: () => el.method != null
                      ? el.method(model)
                      : el.child == null
                          ? DiscuzToast.failed(
                              context: context, message: '暂时不支持的功能')
                          : DiscuzRoute.open(
                              context: context, widget: el.child),
                ),
                const DiscuzDivider()
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

  const _AccountMenuItem(
      {@required this.label,
      @required this.icon,
      this.separate = false,
      this.method,
      this.child});
}

/// 我的账号头部信息
class _MyAccountCard extends StatelessWidget {
  const _MyAccountCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: true,
      builder: (context, child, model) => Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: DiscuzListTile(
              leading: DiscuzAvatar(
                size: 55,
              ),
              title: DiscuzText(
                model.user['attributes']['username'] ?? '',
                fontSize: DiscuzApp.themeOf(context).largeTextSize,
              ),

              /// todo: 增加bio显示，待接口反馈
              subtitle: DiscuzText(
                '现在还没有BIO支持',
                color: DiscuzApp.themeOf(context).greyTextColor,
              ),
            ),
          ));
}
