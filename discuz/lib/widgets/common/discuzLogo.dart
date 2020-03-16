import 'package:flutter/material.dart';

class DiscuzAppLogo extends StatelessWidget {
  final double width;
  final double height;
  final double circular;
  final double bottom;
  final Color color;

  const DiscuzAppLogo(
      {this.width = 120,
      this.height = 50,
      this.bottom = 10,
      this.color = const Color(0xFFFFFFFF),
      this.circular = 15});
  @override
  Widget build(BuildContext context) => SizedBox(
          child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        width: width,
        height: height,
      ));
}
