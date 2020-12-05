import 'package:flutter/material.dart';

import 'package:core/widgets/ui/ui.dart';

class DiscuzLink extends StatelessWidget {
  final Function onDoubleTap;
  final Function onTap;
  final String label;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const DiscuzLink(
      {Key key,
      this.onDoubleTap,
      this.onTap,
      this.label = '未知',
      this.fontSize,
      this.padding = const EdgeInsets.only(left: 5, right: 5)});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onDoubleTap: onDoubleTap,
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: DiscuzApp.themeOf(context).primaryColor,
                fontSize:
                    fontSize ?? DiscuzApp.themeOf(context).normalTextSize),
          ),
        ),
      );
}
