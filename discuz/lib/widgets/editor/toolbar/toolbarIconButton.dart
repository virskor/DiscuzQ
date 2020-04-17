import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/ui/ui.dart';

///
/// 点击表情按钮
///
class ToolbarIconButton extends StatelessWidget {
  final IconData icon;

  const ToolbarIconButton({@required this.icon});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: DiscuzIcon(
          icon,
          color: DiscuzApp.themeOf(context).greyTextColor,
        ),
      );
}
