import 'package:core/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:core/widgets/common/discuzText.dart';

class AppbarSaveButton extends StatelessWidget {
  final Function onTap;
  final String label;

  AppbarSaveButton({Key key, this.label = '完成', @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Container(
          constraints: BoxConstraints(minHeight: 40),
          padding:
              const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: DiscuzApp.themeOf(context).primaryColor,
          ),
          child: DiscuzText(
            label,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
