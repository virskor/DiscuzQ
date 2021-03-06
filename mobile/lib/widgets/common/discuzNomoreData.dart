import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzText.dart';

class DiscuzNoMoreData extends StatelessWidget {
  const DiscuzNoMoreData(
      {Key key,
      this.padding = const EdgeInsets.only(top: 20),
      this.children = const [],
      this.caption = "没有更多了"})
      : super(key: key);

  final EdgeInsets padding;

  final String caption;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        children: [
          Image.asset(
            "assets/images/inbox.png",
            width: 60,
          ),
          const SizedBox(
            height: 10,
          ),
          DiscuzText(
            caption,
            isGreyText: true,
          ),
          ...children
        ],
      ),
    );
  }
}
