import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/providers/forumProvider.dart';

class AboutAppFooter extends StatelessWidget {
  const AboutAppFooter();

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          bottom: true,
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _company,
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
              DiscuzText(
                'Powered by Discuz!Q & Disucz!Q for Flutter',
                color: DiscuzApp.themeOf(context).greyTextColor,
                fontSize: DiscuzApp.themeOf(context).miniTextSize,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

  Widget get _company => Consumer<ForumProvider>(
      builder: (BuildContext context, ForumProvider forum, Widget child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DiscuzLink(
                label: forum.forum.attributes.setSite.siteName,
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
          ));
}
