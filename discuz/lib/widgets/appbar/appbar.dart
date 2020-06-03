import 'dart:io';

import 'package:discuzq/utils/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

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
      this.elevation = 0,
      this.automaticallyImplyLeading = false,
      @required this.title,
      this.dark = false,
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

  final Size preferredSize = const Size.fromHeight(kToolbarHeight - 5);

  ///
  /// 创建 APPbar 标题
  Widget _title() => title.runtimeType == String
      ? DiscuzText(
          title,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.1,
          color: dark ? Colors.white : null,
        )
      : title;

  ///
  /// 生成阴影，ios下默认不带阴影(海拔)，除非用户提供
  /// 但是安卓则需要
  double _computeElevation() {
    if (Device.isWeb) {
      return 0;
    }
    return elevation == 0 && Platform.isAndroid ? 10 : elevation;
  }

  @override
  Widget build(BuildContext context) => AppBarExt(
        title: _title(),
        elevation: _computeElevation(),
        bottomOpacity: bottomOpacity,
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: centerTitle,
        leadingWidth: ModalRoute.of(context).canPop == true &&
                ModalRoute.of(context).isFirst == false
            ? leadingWidth > 0 ? leadingWidth : 100
            : kToolbarHeight,
        leading: leading ??
            AppbarLeading(
              previousPageTitle: previousPageTitle,
              dark: dark,
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

class AppbarLeading extends StatelessWidget {
  final IconData codePoint;
  final double size;
  final String previousPageTitle;
  final bool dark;

  const AppbarLeading(
      {Key key,
      this.codePoint = SFSymbols.arrow_left,
      this.size = 25,
      this.dark = false,
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

  Widget _button({BuildContext context}) {
    if (Platform.isIOS) {
      return GestureDetector(
        child: Row(
          children: <Widget>[
            Icon(
              SFSymbols.chevron_left,
              size: size,
              color:
                  dark ? Colors.white : DiscuzApp.themeOf(context).primaryColor,
            ),
            DiscuzText(
              previousPageTitle,
              color: DiscuzApp.themeOf(context).primaryColor,
            )
          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }

    return IconButton(
      tooltip: previousPageTitle,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        codePoint,
        size: size,
        color: dark ? Colors.white : DiscuzApp.themeOf(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
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
