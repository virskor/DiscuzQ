import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/search/searchUserDelegate.dart';

class SearchTypeItemsColumn extends StatelessWidget {
  const SearchTypeItemsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => DiscuzRoute.open(
              context: context,
              shouldLogin: true,
              fullscreenDialog: true,
              widget: const SearchUserDelegate()),
          child: const _SearchTypeItem(
            label: '搜索用户',
            colors: <Color>[Color(0xff0c6ae4), Color(0xff0f57b5)],
            icon: SFSymbols.person_crop_circle_badge_plus,
          ),
        ),
        GestureDetector(
          onTap: () => DiscuzToast.failed(context: context, message: '暂不支持'),
          child: const _SearchTypeItem(
            label: '搜索主题',
            colors: <Color>[Color(0xff444444), Color(0xff888888)],
            icon: SFSymbols.search_circle_fill,
          ),
        )
      ],
    );
  }
}

class _SearchTypeItem extends StatelessWidget {
  ///
  /// 选项标题
  final String label;

  ///
  /// 渐变色
  final List<Color> colors;

  final IconData icon;

  const _SearchTypeItem(
      {this.label = '',
      this.colors = const [Colors.green, Colors.blue],
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DiscuzText(
            label,
            color: Colors.white70,
            textScaleFactor: 2,
            fontWeight: FontWeight.bold,
          ),
          DiscuzIcon(
            icon,
            color: Colors.white70,
            size: 40,
          )
        ],
      ),
    );
  }
}
