import 'package:flutter/material.dart';

class DiscuzAppLogo extends StatelessWidget {
  const DiscuzAppLogo(
      {this.width = 120, this.height = 120, this.circular = 25});

  final double width;
  final double height;
  final double circular;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(circular)),
      child: Image.asset(
        'assets/images/app.png',
        fit: BoxFit.fill,
        width: width,
        height: height,
      ));
}
