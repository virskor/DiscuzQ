import 'package:flutter/material.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/views/searchAndExplore/appSearchDelegate.dart';
import 'package:discuzq/widgets/search/searchActionButton.dart';

class ForumCategoryTabWrapper extends StatelessWidget {
  ForumCategoryTabWrapper({Key key, this.tabBar});

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
              SafeArea(top: true, bottom: false, child: tabBar),
              Positioned(
                right: 0,
                child: _actionButtons,
              )
            ],
          )));

  Widget get _actionButtons => Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.4),
        ),
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
