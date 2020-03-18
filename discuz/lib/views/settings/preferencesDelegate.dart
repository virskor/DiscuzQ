import 'package:discuzq/widgets/settings/themeColorSetting.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class PreferencesDelegate extends StatefulWidget {
  const PreferencesDelegate({Key key}) : super(key: key);
  @override
  _PreferencesDelegateState createState() => _PreferencesDelegateState();
}

class _PreferencesDelegateState extends State<PreferencesDelegate> {
  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              elevation: 10,
              centerTitle: true,
              title: '偏好设置',
            ),
            body: Column(
              children: <Widget>[
                const ThemeColorSetting(),
              ],
            ),
          ));
}
