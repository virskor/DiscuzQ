import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

///
///
/// Notice this code this written by Nizwar
/// https://github.com/nizwar/ndialog
/// https://pub.dev/packages/ndialog
///
///
class BlurDialogBackground extends StatelessWidget {
  ///Widget of dialog, you can use NDialog, Dialog, AlertDialog or Custom your own Dialog
  final Widget child;

  ///Because blur dialog cover the barrier, you have to declare here
  final bool dismissable;

  ///Action before dialog dismissed
  final Function onDismiss;

  /// Creates an background filter that applies a Gaussian blur.
  /// Default = 3.0
  final double blur;

  final Color color;

  const BlurDialogBackground(
      {Key key,
      this.child,
      this.dismissable,
      this.blur,
      this.onDismiss,
      this.color = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: WillPopScope(
        onWillPop: () async {
          if (dismissable ?? true) {
            if (onDismiss != null) onDismiss();
            Navigator.pop(context);
          }
          return;
        },
        child: Stack(
            overflow: Overflow.clip,
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: dismissable ?? true
                    ? () {
                        if (onDismiss != null) {
                          onDismiss();
                        }
                        Navigator.pop(context);
                      }
                    : () {},
                child: ControlledAnimation(
                  tween: Tween<double>(begin: 0, end: blur ?? 3),
                  duration: Duration(milliseconds: 270),
                  builder: (context, val) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: val,
                        sigmaY: val,
                      ),
                      child: Container(
                        color: color,
                      ),
                    );
                  },
                ),
              ),
              child
            ]),
      ),
    );
  }
}
