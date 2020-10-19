import 'package:flutter/material.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/views/searchAndExplore/appSearchDelegate.dart';
import 'package:discuzq/widgets/search/searchActionButton.dart';

class ForumCategoryTabWrapper extends StatelessWidget {
  const ForumCategoryTabWrapper({Key key, this.tabBar});

  /// child tab
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: state.appConf['darkTheme']
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
                child: _actionButtons(state: state, context: context),
              )
            ],
          )));

  ///
  /// 分类
  Widget _actionButtons({AppState state, BuildContext context}) => Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: state.appConf['darkTheme']
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
