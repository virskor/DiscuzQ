import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/ui/ui.dart';

class AppbarLeading extends StatelessWidget {
  final IconData codePoint;
  final double size;
  final String previousPageTitle;
  final bool dark;
  final removePreviousPageTitle;

  const AppbarLeading(
      {Key key,
      this.codePoint = CupertinoIcons.arrow_left,
      this.size = 25,
      this.dark = false,
      this.removePreviousPageTitle = false,
      this.previousPageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RepaintBoundary(
      child: Container(
          alignment: Alignment.centerLeft,
          child: ModalRoute.of(context).canPop == true &&
                  ModalRoute.of(context).isFirst == false
              ? _button(context: context)
              : null));

  Widget _button({BuildContext context}) => IconButton(
        tooltip: previousPageTitle,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Platform.isIOS ? CupertinoIcons.chevron_left : codePoint,
          size: size,
          color: dark ? Colors.white : DiscuzApp.themeOf(context).textColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
}

class DiscuzAppBarActions extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final bool preventPadding;
  final Color color;
  final EdgeInsetsGeometry margin;
  static const Widget _defaultChild = const SizedBox();

  DiscuzAppBarActions(
      {Key key,
      this.onTap,
      this.child = _defaultChild,
      this.preventPadding,
      this.color = Colors.transparent,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(right: 10, top: 0),
        padding: preventPadding == true ? null : const EdgeInsets.all(5),
        constraints: const BoxConstraints(maxWidth: 100, minHeight: 60),
        child: Material(
          child: child,
          color: color,
        ),
      ),
    );
  }
}
