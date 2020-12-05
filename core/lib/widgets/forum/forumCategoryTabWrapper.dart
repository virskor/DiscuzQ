import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/search/searchActionButton.dart';
import 'package:core/widgets/search/searchTypeItemsColumn.dart';
import 'package:core/providers/appConfigProvider.dart';

class ForumCategoryTabWrapper extends StatelessWidget {
  const ForumCategoryTabWrapper({Key key, this.tabBar});

  /// child tab
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) => Consumer<AppConfigProvider>(
      builder: (BuildContext context, AppConfigProvider conf, Widget child) =>
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: conf.appConf['darkTheme']
                      ? DiscuzApp.themeOf(context).scaffoldBackgroundColor
                      : DiscuzApp.themeOf(context).primaryColor),
              child: Stack(
                children: <Widget>[
                  SafeArea(
                      top: true,
                      bottom: false,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: tabBar)),
                  Positioned(
                    right: 0,
                    child: _actionButtons(conf: conf, context: context),
                  )
                ],
              )));

  ///
  /// 分类
  Widget _actionButtons({dynamic conf, BuildContext context}) => Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: conf.appConf['darkTheme']
                ? DiscuzApp.themeOf(context).scaffoldBackgroundColor
                : DiscuzApp.themeOf(context).primaryColor),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Row(
            children: <Widget>[
              const DiscuzAppSearchActionButton(
                type: DiscuzAppSearchType.thread,
              ),
            ],
          ),
        ),
      );
}
