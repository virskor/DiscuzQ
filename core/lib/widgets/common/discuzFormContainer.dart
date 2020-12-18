import 'package:core/utils/global.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscuzFormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  DiscuzFormContainer({@required this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).backgroundColor,
          border: const Border(top: Global.border, bottom: Global.border)),

      /// SingleChildScrollView 防止设备不同的情况下，overflow渲染错误
      child: child,
    );
  }
}
