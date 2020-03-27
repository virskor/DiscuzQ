import 'package:flutter/material.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/utils/global.dart';

class AboutAppFooter extends StatelessWidget {
  const AboutAppFooter();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _company(context: context),
            DiscuzText(
              'Copyright © 2019-2027 ${Global.domain} All Rights Reserved',
              color: DiscuzApp.themeOf(context).greyTextColor,
              fontSize: DiscuzApp.themeOf(context).miniTextSize,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _company({BuildContext context}) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DiscuzLink(
            label: Global.appname,
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
