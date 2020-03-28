import 'package:flutter/material.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';

class AboutAppFooter extends StatelessWidget {
  const AboutAppFooter();

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Container(
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              bottom: true,
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _company(context: context, state: state),
                  DiscuzText(
                    Global.domain,
                    color: DiscuzApp.themeOf(context).greyTextColor,
                    fontSize: DiscuzApp.themeOf(context).miniTextSize,
                    overflow: TextOverflow.ellipsis,
                  ),
                  DiscuzText(
                    'Copyright © 2019-2027 All Rights Reserved',
                    color: DiscuzApp.themeOf(context).greyTextColor,
                    fontSize: DiscuzApp.themeOf(context).miniTextSize,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ));

  Widget _company({BuildContext context, AppState state}) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DiscuzLink(
            label: state.forum.attributes.setSite.siteName,
            fontSize: DiscuzApp.themeOf(context).miniTextSize,
            onTap: () => WebviewHelper.launchUrl(url: Global.domain),
          ),
          const SizedBox(
            width: 10,
          ),
          DiscuzText(
            '版权所有',
            color: DiscuzApp.themeOf(context).greyTextColor,
            fontSize: DiscuzApp.themeOf(context).miniTextSize,
          ),
        ],
      );
}
