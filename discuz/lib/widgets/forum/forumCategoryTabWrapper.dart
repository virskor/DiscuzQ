import 'package:flutter/material.dart';

import 'package:discuzq/widgets/forum/forumAddButton.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';

const EdgeInsetsGeometry _kPaddingRightInsets = EdgeInsets.only(right: 60);

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
          child: SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: _kPaddingRightInsets,
                  child: tabBar,
                ),
                Positioned(
                  right: 10,
                  child: _actionButtons,
                )
              ],
            ),
          )));

  Widget get _actionButtons => Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            const ForumAddButton(
              awalysDark: true,
            )
          ],
        ),
      );
}
