import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:badges/badges.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/authHelper.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';

class NotificationsDelegate extends StatefulWidget {
  const NotificationsDelegate({Key key}) : super(key: key);
  @override
  _NotificationsDelegateState createState() => _NotificationsDelegateState();
}

class _NotificationsDelegateState extends State<NotificationsDelegate> {
  ///
  /// _controller refresh
  ///
  final RefreshController _controller = RefreshController();

  /// states
  ///
  /// menus
  ///
  List<_NotificationMenuItem> _menus = <_NotificationMenuItem>[
    const _NotificationMenuItem(
      label: '回复我的',
    ),
    const _NotificationMenuItem(label: '打赏我的'),
    const _NotificationMenuItem(label: '点赞我的'),
    const _NotificationMenuItem(label: '系统通知'),
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

    ///
    /// 窗体准备完毕后，过几秒为用户刷新信息啦
    /// 这种不会从接口刷新，仅从状态刷新，如果用户要刷新还是得下拉
    /// 或者其他交互逻辑涉及调用 Authhelper.refreshUser 也会自动刷新的
    ///
    Future.delayed(Duration(milliseconds: 500))
        .then((_) => _refreshStateOnly());
  }

  @override
  void dispose() {
    _controller.dispose();

    /// do not forget to dispose _controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              title: '通知提醒',
            ),
            body: DiscuzRefresh(
              enablePullDown: true,
              enablePullUp: false,
              // header: WaterDropHeader(),
              controller: _controller,
              onRefresh: () async {
                await _refreshMessageList(context: context, model: model);
                _controller.refreshCompleted();
              },
              child: _buildMessageList(),
            ),
          ));

  ///
  /// 生成通知列表
  /// 通知列表的具体数据，根据 _menus 生成
  /// 具体的更新逻辑，参考 _refreshMessageList
  ///
  Widget _buildMessageList() => SingleChildScrollView(
        child: Column(
          children: _menus
              .map((el) => Container(
                    decoration: BoxDecoration(
                        color: DiscuzApp.themeOf(context).backgroundColor),
                    child: Column(
                      children: <Widget>[
                        DiscuzListTile(
                          title: DiscuzText(el.label),

                          ///
                          /// 点击查看消息
                          ///
                          onTap: () => el.child == null
                              ? DiscuzToast.failed(
                                  context: context, message: '暂不支持')
                              : DiscuzRoute.open(
                                  context: context, widget: el.child),
                          trailing: el.badges != null && el.badges > 0
                              ? Badge(
                                  /// 显示消息条目长度
                                  badgeContent: DiscuzText(
                                    el.badges.toString(),
                                    color: Colors.white,
                                  ),
                                  animationType: BadgeAnimationType.fade,
                                  elevation: 0,
                                  child: const Icon(
                                    SFSymbols.chevron_right,
                                    color: const Color(0xFFDEDEDE),
                                    size: 20,
                                  ),
                                )
                              : const DiscuzListTileTrailing(),
                        ),
                        const DiscuzDivider(),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );

  ///
  /// 下拉刷新列表
  /// 刷新列表的时候，要更新用户信息
  /// 其实这个信息不需要重构，直接从用户信息下取就可以了
  /// unreadNotifications	int		未读消息数
  /// typeUnreadNotifications	array		未读消息数明细
  /// typeUnreadNotifications.replied	array		未读回复消息数
  /// typeUnreadNotifications.liked	array		未读点赞消息数
  /// typeUnreadNotifications.rewarded	array		未读打赏消息数
  /// typeUnreadNotifications.system	array		未读系统消息数
  /// #返回示例
  ///
  Future<void> _refreshMessageList(
      {BuildContext context, AppModel model}) async {
    final bool refreshed =
        await AuthHelper.refreshUser(context: context, model: model);
    if (!refreshed) {
      DiscuzToast.failed(context: context, message: '刷新失败');
      return;
    }

    _refreshStateOnly(model: model);
  }

  ///
  /// 仅刷新状态
  /// 页面initState 和 _refreshMessageList 都会刷新状态
  void _refreshStateOnly({AppModel model}) {
    if (model == null) {
      try {
        model = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
      } catch (e) {
        print(e);
      }
    }

    ///
    /// 刷新列表
    /// 数据为空则不要继续
    ///
    if (model.user['attributes']['typeUnreadNotifications'] == null ||
        model.user['attributes']['typeUnreadNotifications'].length == 0) {
      return;
    }

    final Map<String, dynamic> typeUnreadNotifications =
        model.user['attributes']['typeUnreadNotifications'];
    if (typeUnreadNotifications == null) {
      return;
    }

    ///
    /// 刷新状态
    /// 消息数目就会自动刷新
    /// 要处理null，因为有时候可能没有对应的数据
    /// 就是那么懒
    /// todo:增加消息查看组件
    setState(() {
      _menus = <_NotificationMenuItem>[
        _NotificationMenuItem(
          label: '回复我的',
          badges: typeUnreadNotifications['replied'] ?? 0,
        ),
        _NotificationMenuItem(
          label: '打赏我的',
          badges: typeUnreadNotifications['rewarded'] ?? 0,
        ),
        _NotificationMenuItem(
          label: '点赞我的',
          badges: typeUnreadNotifications['liked'] ?? 0,
        ),
        _NotificationMenuItem(
          label: '系统通知',
          badges: typeUnreadNotifications['system'] ?? 0,
        ),
      ];
    });
  }
}

///
/// 菜单条目
class _NotificationMenuItem {
  /// 选项名称
  final String label;

  /// badges 数量
  final int badges;

  /// child 用于查看消息的组件
  final Widget child;

  const _NotificationMenuItem({@required this.label, this.badges, this.child});
}
