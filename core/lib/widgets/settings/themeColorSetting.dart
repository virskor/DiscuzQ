import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/common/discuzDivider.dart';
import 'package:core/providers/appConfigProvider.dart';

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
    return Consumer<AppConfigProvider>(
        builder: (BuildContext context, AppConfigProvider conf, Widget child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                    children: _themes.map((Color color) {
                  return _colorPick(context, conf, color: color);
                }).toList())
              ],
            ),
          ),
          const DiscuzDivider(
            padding: 0,
          ),
        ],
      );
    });
  }

  ///
  /// 选择器
  ///
  Widget _colorPick(BuildContext context, dynamic conf, {Color color}) =>
      GestureDetector(
        onTap: () => context
            .read<AppConfigProvider>()
            .update(key: 'themeColor', value: color.value),
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
            child: Color(conf.appConf['themeColor']) != color
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
