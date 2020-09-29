import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/utils/appConfigurations.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';

class ThemeColorSetting extends StatelessWidget {
  const ThemeColorSetting({Key key}) : super(key: key);

  static const List<Color> _themes = [
    Color(0xFF007AFF),
    Color(0xFF316598),
    Color(0xFF1DA1F2),
    Color(0xFF05A9F1),
    Color(0xFF04BBD3),
    Color(0xFF3EAF7C),
    Color(0xFFCE0A0C),
    Color(0xFFEA2165),
    Color(0xFF9F28B5),
    Color(0xFFCE8CBA),
    Color(0xFF693DB5),
    Color(0xFF4FB258),
    Color(0xFFFF9802),
    Color(0xFF7A4D2F),
    Color(0xFF3736DD),
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    bottom: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                        children: _themes.map((Color color) {
                      return _colorPick(context, state, color: color);
                    }).toList())
                  ],
                ),
              ),
              const DiscuzDivider(padding: 0,),
            ],
          );
        });
  }

  ///
  /// 选择器
  ///
  Widget _colorPick(BuildContext context, AppState state,
          {double width = 1.0, Color color}) =>
      GestureDetector(
        onTap: () => AppConfigurations()
            .update(context: context, key: 'themeColor', value: color.value),
        child: AnimatedContainer(
          margin: const EdgeInsets.only(left: 10, top: 5),
          duration: const Duration(
            milliseconds: 300,
          ),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          child: Center(
            child: Color(state.appConf['themeColor']) != color
                ? const SizedBox()
                : Container(
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
}
