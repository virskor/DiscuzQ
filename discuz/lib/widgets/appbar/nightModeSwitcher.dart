import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class NightModeSwitcher extends StatelessWidget {
  final Color color;

  const NightModeSwitcher({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) {
          return IconButton(
            icon: DiscuzIcon(
              state.appConf['darkTheme'] == false
                  ? CupertinoIcons.sun_max_fill
                  : CupertinoIcons.moon_fill,
              color: color ?? DiscuzApp.themeOf(context).textColor,
            ),
            onPressed: () => AppConfigurations().update(
                context: context,
                key: 'darkTheme',
                value: !state.appConf['darkTheme']),
          );
        });
  }
}
