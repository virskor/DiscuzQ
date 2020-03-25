import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class PostDetBot extends StatelessWidget {
  ///
  /// 要显示的主题
  ///
  final ThreadModel thread;

  PostDetBot({@required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DiscuzText(
            "${thread.attributes.postCount.toString()}回复",
            color: DiscuzApp.themeOf(context).greyTextColor,
          ),
          Row(
            children: <Widget>[
              DiscuzLink(
                label: '分享',
                onTap: () => null,
              ),
              DiscuzLink(
                label: thread.attributes.isFavorite ? '已收藏' : '收藏',
                onTap: () => null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
