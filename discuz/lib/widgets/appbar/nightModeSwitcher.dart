import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/ui/ui.dart';

class NightModeSwitcher extends StatelessWidget {
  const NightModeSwitcher({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        rebuildOnChange: false,
        builder: (context, child, model) {
          return IconButton(
            icon: DiscuzIcon(
              model.appConf['darkTheme'] == false
                  ? SFSymbols.sun_min_fill
                  : SFSymbols.moon_fill,
              color: DiscuzApp.themeOf(context).textColor,
            ),
            onPressed: () => AppConfigurations().update(
                context: context,
                key: 'darkTheme',
                value: !model.appConf['darkTheme']),
          );
        });
  }
}
