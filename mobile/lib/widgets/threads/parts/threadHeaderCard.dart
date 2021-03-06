import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/utils/dateUtil.dart';
import 'package:discuzq/widgets/common/discuzChip.dart';

///
/// ThreadHeaderCard
/// 故事的顶部信息显示
class ThreadHeaderCard extends StatelessWidget {
  ///
  /// 作者
  final UserModel author;

  ///
  /// 故事
  final ThreadModel thread;

  ///
  /// 是否显示更多操作
  final bool showOperations;

  const ThreadHeaderCard(
      {@required this.author,
      @required this.thread,
      this.showOperations = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Row(
        children: <Widget>[
          ///
          /// user avatar
          GestureDetector(
            onTap: () {
              DiscuzRoute.navigate(
                  context: context,
                  shouldLogin: true,
                  widget: UserHomeDelegate(
                    user: author,
                  ));
            },
            child: DiscuzAvatar(
              size: 35,
              url: author.attributes.avatarUrl,
            ),
          ),

          /// userinfo
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DiscuzText(
                    author.attributes.username,
                    fontWeight: FontWeight.bold,
                  ),
                  DiscuzText(
                    ///
                    /// 格式化时间
                    DiscuzMomentTimeFormat.format(
                        DateTime.tryParse(thread.attributes.createdAt)),
                    color: DiscuzApp.themeOf(context).greyTextColor,
                    fontSize: DiscuzApp.themeOf(context).smallTextSize,
                  )
                ],
              ),

              /// pop menu
            ),
          ),

          /// isSticky
          thread.attributes.isSticky
              ? const Expanded(
                  flex: 1,
                  child: const DiscuzChip(
                    label: '顶置',
                  ))
              : const SizedBox(),

          /// isEssence
          thread.attributes.isEssence
              ? const Expanded(
                  flex: 1,
                  child: const Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                      ),
                      child: const DiscuzChip(
                        label: '精华',
                        color: Colors.pink,
                      )))
              : const SizedBox(),
        ],
      ),
    );
  }
}
