import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DiscuzIndicator extends StatelessWidget {

  ///
  /// brigtness
  final Brightness brightness;

  ///
  /// scale it to be smaller or lager
  final double scale;

  ///
  /// animating or not
  final bool animating;


  const DiscuzIndicator(
      {Key key, this.brightness = Brightness.light, this.scale = 1, this.animating = true});

  @override
  Widget build(BuildContext context) => Transform.scale(
        scale: scale,
        child: Theme(
            data: ThemeData(
                cupertinoOverrideTheme:
                    CupertinoThemeData(brightness: brightness)),
            child: CupertinoActivityIndicator(animating: animating,)),
      );
}
