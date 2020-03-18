import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:badges/badges.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';

class NotificationsDelegate extends StatefulWidget {
  const NotificationsDelegate({Key key}) : super(key: key);
  @override
  _NotificationsDelegateState createState() => _NotificationsDelegateState();
}

class _NotificationsDelegateState extends State<NotificationsDelegate> {
  /// states
  ///
  /// menus
  ///
  List<_NotificationMenuItem> _menus = <_NotificationMenuItem>[
    const _NotificationMenuItem(label: '回复我的', badges: 20),
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
    /// 自动刷新消息条目，并异步更新UI
    this._refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              elevation: 10,
              title: '通知提醒',
            ),
            body: SingleChildScrollView(
              child: Column(
                children: _menus
                    .map((el) => Container(
                          decoration: BoxDecoration(
                              color:
                                  DiscuzApp.themeOf(context).backgroundColor),
                          child: Column(
                            children: <Widget>[
                              DiscuzListTile(
                                title: DiscuzText(el.label),
                                trailing: el.badges != null && el.badges > 0
                                    ? Badge(   /// 显示消息条目长度
                                        badgeContent: DiscuzText(
                                          el.badges.toString(),
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          SFSymbols.chevron_right,
                                          color: const Color(0xFFDEDEDE),
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
            ),
          ));

  ///
  /// todo: 刷新消息列表
  /// 请求结束后重构 _menus
  ///
  Future<void> _refresh() async {}
}

///
/// 菜单条目
class _NotificationMenuItem {
  /// 选项名称
  final String label;

  /// badges 数量
  final int badges;

  const _NotificationMenuItem({@required this.label, this.badges});
}
