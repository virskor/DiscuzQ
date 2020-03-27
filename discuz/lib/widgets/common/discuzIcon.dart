import 'package:flutter/material.dart';

import 'package:discuzq/widgets/ui/ui.dart';

class DiscuzIcon extends StatelessWidget {
  final double size;
  final dynamic icon;
  final Color color;

  const DiscuzIcon(this.icon, {Key key, this.size = 24, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon.runtimeType == int ? IconData(icon, fontFamily: 'iconfont') : icon,
      size: size,
      color: color ?? DiscuzApp.themeOf(context).primaryColor,
    );
  }
}
