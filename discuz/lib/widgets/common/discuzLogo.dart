import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscuzAppLogo extends StatelessWidget {
  final double width;
  final double height;
  final double circular;
  final double bottom;
  final Color color;
  final bool dark;

  const DiscuzAppLogo(
      {this.width = 120,
      this.height = 50,
      this.bottom = 10,
      this.dark = false,
      this.color = const Color(0xFFFFFFFF),
      this.circular = 15});
  @override
  Widget build(BuildContext context) => SizedBox(
          child: Image.asset(
        'assets/images/discuzapptitle.png',
        fit: BoxFit.contain,
        color: dark ? Colors.white : DiscuzApp.themeOf(context).primaryColor,
        width: width,
        height: height,
      ));
}
