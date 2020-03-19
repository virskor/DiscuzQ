import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class SiteinfoDelegate extends StatefulWidget {
  final Function onRequested;

  const SiteinfoDelegate({Key key, this.onRequested}) : super(key: key);
  @override
  _SiteinfoDelegateState createState() => _SiteinfoDelegateState();
}

class _SiteinfoDelegateState extends State<SiteinfoDelegate> {
  final List<_SiteInfoBindingItems> _items = [
    const _SiteInfoBindingItems(
        label: '站点名称', group: 'set_site', childName: 'site_name'),
    const _SiteInfoBindingItems(
        label: '站点图片',
        group: 'set_site',
        childName: 'site_logo',
        isImage: true),
    const _SiteInfoBindingItems(
        label: '站点简介', group: 'set_site', childName: 'site_introduction'),
    const _SiteInfoBindingItems(
        label: '创建时间', group: 'set_site', childName: 'site_install'),
    // const _SiteInfoBindingItems(
    //     label: '站长', group: 'set_site', childName: 'site_author'),
    // const _SiteInfoBindingItems(
    //     label: '加入时间',
    //     group: 'user',
    //     childName: 'register_time',
    //     separate: true),
  ];

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '站点信息',
            ),
            backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
            body: _body(state),
          ));

  Widget _body(AppState state) => ListView(
        children: _items
            .map((it) => Container(
                  margin: it.separate == true
                      ? const EdgeInsets.only(top: 20)
                      : null,
                  decoration: BoxDecoration(
                      border: const Border(top: Global.border),
                      color: DiscuzApp.themeOf(context).backgroundColor),
                  child: DiscuzListTile(
                    leading: DiscuzText(it.label),
                    trailing: it.isImage == false
                        ? DiscuzText(
                            state.forum[it.group][it.childName],
                            color: DiscuzApp.themeOf(context).greyTextColor,
                          )
                        : const SizedBox(),

                    /// todo: 如果是图片则默认使用logo
                  ),
                ))
            .toList(),
      );
}

/// 站点信息绑定数据
class _SiteInfoBindingItems {
  /// 值 对应的key
  final String childName;

  /// 对应的分类
  final String group;

  /// 标签名称
  final String label;

  /// 是否是图片
  final bool isImage;

  /// 分割
  final bool separate;

  /// 仅在用户登录后展示
  final bool shouldLogin;

  const _SiteInfoBindingItems(
      {this.childName,
      this.group = 'set_site',
      this.separate = false,
      this.label = '未知项目',
      this.shouldLogin = false,
      this.isImage = false});
}
