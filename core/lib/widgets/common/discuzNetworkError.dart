import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:flutter/material.dart';

class DiscuzNetworkError extends StatelessWidget {
  final Function onRequestRefresh;
  final String label;

  const DiscuzNetworkError(
      {Key key, this.label = '加载失败，重新试试', this.onRequestRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/error.png",
              width: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            DiscuzButton(
              label: label,
              color: Colors.transparent,
              labelColor: DiscuzApp.themeOf(context).textColor,
              onPressed: onRequestRefresh,
            )
          ],
        ),
      ),
    );
  }
}
