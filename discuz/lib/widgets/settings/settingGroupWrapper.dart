import 'package:flutter/material.dart';


import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class SettingGroupWrapper extends StatelessWidget {
  final List<Widget> children;
  final String label;

  const SettingGroupWrapper({this.children, this.label = '未分组'});

  @override
  Widget build(BuildContext context) {
    List<Widget> rebuildChildren = [...children];
    rebuildChildren.insert(
        0,
        DiscuzText(
          label,
          fontSize: DiscuzApp.themeOf(context).normalTextSize,
          color: DiscuzApp.themeOf(context).greyTextColor,
        ));

    rebuildChildren.insert(0, const SizedBox(height: 10));

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rebuildChildren,
      ),
    );
  }
}
