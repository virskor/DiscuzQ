import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/providers/appConfigProvider.dart';

class NightModeSwitcher extends StatelessWidget {
  final Color color;

  const NightModeSwitcher({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AppConfigProvider>(
        builder: (BuildContext context, AppConfigProvider conf, Widget child) {
      return IconButton(
        icon: DiscuzIcon(
          conf.appConf['darkTheme'] == false
              ? CupertinoIcons.sun_max_fill
              : CupertinoIcons.moon_fill,
          color: color ?? DiscuzApp.themeOf(context).textColor,
        ),
        onPressed: () => context.read<AppConfigProvider>().update(
            key: 'darkTheme',
            value: !conf.appConf['darkTheme']),
      );
    });
  }
}
