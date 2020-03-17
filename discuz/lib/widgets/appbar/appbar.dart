import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';

class DiscuzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final double height;
  final double elevation;
  final bool dark;
  final bool autoBuildCupertino;
  final bool forceCupertino;
  final dynamic title;
  final List<Widget> actions;
  final Widget leading;
  final String previousPageTitle;
  final bool dense;
  final bool transitionAnimation;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double leadingWidth;
  final Brightness brightness;
  final Widget bottom;
  final double bottomOpacity;
  final double toolbarOpacity;

  const DiscuzAppBar(
      {Key key,
      this.height,
      this.elevation,
      this.automaticallyImplyLeading = false,
      @required this.title,
      this.dark,
      this.actions,
      this.toolbarOpacity = 1,
      this.leadingWidth = 0,
      this.centerTitle = true,
      this.forceCupertino,
      this.bottomOpacity = 1,
      this.autoBuildCupertino = true,
      this.leading,
      this.previousPageTitle = '返回',
      this.dense = true,
      this.transitionAnimation = true,
      this.bottom,
      this.brightness,
      this.backgroundColor})
      : super(key: key);

  final Size preferredSize = const Size.fromHeight(kToolbarHeight - 10);

  Widget _title() => title.runtimeType == String
      ? Text(
          title,
          overflow: TextOverflow.ellipsis,
        )
      : title;

  @override
  Widget build(BuildContext context) => AppBarExt(
        title: _title(),
        elevation: elevation,
        bottomOpacity: bottomOpacity,
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: centerTitle,
        leadingWidth: ModalRoute.of(context).canPop == true &&
                ModalRoute.of(context).isFirst == false
            ? leadingWidth > 0 ? leadingWidth : 100
            : kToolbarHeight,
        leading: leading ??
            _Leading(
              previousPageTitle: previousPageTitle,
            ),
        brightness: brightness ?? DiscuzApp.themeOf(context).brightness,
        toolbarOpacity: toolbarOpacity,
        backgroundColor:
            backgroundColor ?? DiscuzApp.themeOf(context).backgroundColor,
        textTheme: TextTheme(
          headline6: TextStyle(
              color: dark == true
                  ? Colors.white
                  : DiscuzApp.themeOf(context).textColor,
              fontWeight: FontWeight.bold,
              fontSize: DiscuzApp.themeOf(context).normalTextSize),
        ),
        actions: actions ?? actions,
        bottom: bottom,
      );
}

class _Leading extends StatelessWidget {
  final IconData codePoint;
  final double size;
  final String previousPageTitle;

  _Leading(
      {Key key,
      this.codePoint = SFSymbols.arrow_left,
      this.size = 25,
      this.previousPageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RepaintBoundary(
      child: Container(
          alignment: Alignment.centerLeft,
          child: ModalRoute.of(context).canPop == true &&
                  ModalRoute.of(context).isFirst == false
              ? IconButton(
                  tooltip: previousPageTitle,
                  icon: Icon(
                    codePoint,
                    size: size,
                    color: DiscuzApp.themeOf(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null));
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
