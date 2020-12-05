import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/views/search/searchThreadDelegate.dart';
import 'package:core/views/search/searchUserDelegate.dart';
import 'package:core/router/route.dart';

enum DiscuzAppSearchType {
  ///
  /// Search for Thread
  thread,

  ///
  /// Search for User
  user,

  ///
  /// Search for topics
  topic
}


class SearchTypeItemsColumn extends StatelessWidget {
  const SearchTypeItemsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ///
        /// 打开用户搜索
        ///
        GestureDetector(
          onTap: () => DiscuzRoute.navigate(
              context: context,
              shouldLogin: true,
              fullscreenDialog: true,
              widget: const SearchUserDelegate()),
          child: const _SearchTypeItem(
            label: '搜索用户',
            colors: <Color>[Color(0xff0c6ae4), Color(0xff0f57b5)],
            icon: CupertinoIcons.person_crop_circle_badge_plus,
          ),
        ),

        ///
        /// 打开帖子搜索
        ///
        GestureDetector(
          onTap: () => DiscuzRoute.navigate(
              context: context,
              shouldLogin: true,
              fullscreenDialog: true,
              widget: const SearchThreadDelegate()),
          child: const _SearchTypeItem(
            label: '搜索主题',
            colors: <Color>[Color(0xff444444), Color(0xff888888)],
            icon: CupertinoIcons.search_circle_fill,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
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
