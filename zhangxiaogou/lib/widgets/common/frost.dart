import 'package:flutter/material.dart';
import 'dart:ui';

class Frost extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double circular;

  const Frost(
      {Key key,
      this.child,
      this.sigmaX = 80,
      this.sigmaY = 40,
      this.circular = 0});

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(circular),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child));
}
