import 'package:flutter/material.dart';

class DiscuzAppLogo extends StatelessWidget {
  const DiscuzAppLogo(
      {Key key,
      this.width = 120,
      this.height = 120,
      this.circular = 25,
      this.transparent = false})
      : super(key: key);

  final double width;
  final double height;
  final double circular;
  final bool transparent;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(circular)),
      child: Image.asset(
        transparent ? 'assets/images/logo.png' : 'assets/images/app.png',
        fit: BoxFit.fill,
        width: width,
        height: height,
      ));
}
