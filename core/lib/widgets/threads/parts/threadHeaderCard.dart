
import 'package:core/widgets/common/discuzChip.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/common/discuzAvatar.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/router/route.dart';
import 'package:core/views/users/userHomeDelegate.dart';
import 'package:core/utils/dateUtil.dart';

///
/// ThreadHeaderCard
/// 主题的顶部信息显示
class ThreadHeaderCard extends StatelessWidget {
  ///
  /// 作者
  final UserModel author;

  ///
  /// 主题
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
      child: Row(
        children: <Widget>[
          ///
          /// user avatar
          GestureDetector(
            onTap: () => DiscuzRoute.navigate(
                context: context,
                shouldLogin: true,
                widget: UserHomeDelegate(
                  user: author,
                )),
            child: DiscuzAvatar(
              size: 35,
              url: author.attributes.avatarUrl,
            ),
          ),

          /// userinfo
          Expanded(
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
                    DateUtil.formatDate(
                        DateTime.parse(thread.attributes.updatedAt).toLocal(),
                        format: "yyyy-MM-dd HH:mm"),
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
              ? const DiscuzChip(
                  label: '顶置',
                )
              : const SizedBox(),

          /// isEssence
          thread.attributes.isEssence
              ? const Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                  ),
                  child: const DiscuzChip(
                    label: '精华',
                    color: Colors.pink,
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
