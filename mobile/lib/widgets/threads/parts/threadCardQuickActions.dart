import 'dart:io';

import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/posts/postLikeButton.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/editor/discuzEditorHelper.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/editor/discuzEditorRequestResult.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/reports/reportsDelegate.dart';
import 'package:discuzq/views/threads/threadDetailDelegate.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';

///
/// 按钮图标的大小
const double _kIconsize = 25;

class ThreadCardQuickActions extends StatelessWidget {
  ///
  /// 首贴
  final PostModel firstPost;

  ///
  /// 关联帖子
  final ThreadModel thread;

  final UserModel author;

  const ThreadCardQuickActions(
      {@required this.firstPost, @required this.thread, @required this.author});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///
          /// 点赞按钮
          Expanded(
            child: PostLikeButton(
              size: _kIconsize,
              post: firstPost,
            ),
          ),

          ///
          /// 评论
          _ThreadCardQuickActionsItem(
            icon: 0xe624,
            count: thread.attributes.postCount - 1,
            iconSize: _kIconsize - 2,
            onPressed: () async {
              final DiscuzEditorRequestResult res =
                  await DiscuzEditorHelper(context: context)
                      .reply(post: firstPost, thread: thread);
              if (res != null) {
                ////
                /// 这种时候，用户是在卡片操作回复的，仅提示回复成功即可
                DiscuzToast.toast(context: context, message: '回复成功');
              }
            },
          ),

          _ThreadCardQuickActionsItem(
              icon: 0xe77f,
              hideCounter: true,
              iconSize: _kIconsize + 5,
              onPressed: () async {
                final result = await showModalActionSheet<String>(
                  context: context,
                  title: '更多操作',
                  cancelLabel: "取消",
                  actions: [
                    const SheetAction(
                      icon: Icons.info,
                      label: '详情',
                      key: 'detail',
                    ),
                    const SheetAction(
                      icon: Icons.flag,
                      label: '举报',
                      key: 'report',
                    ),
                    const SheetAction(
                      icon: Icons.account_circle,
                      label: '查看Ta',
                      key: 'user',
                    ),
                  ],
                );

                print(result);

                if (result == "detail") {
                  DiscuzRoute.navigate(
                      context: context,
                      shouldLogin: true,
                      widget: ThreadDetailDelegate(
                        author: author,
                        thread: thread,
                      ));
                  return;
                }

                if (result == "report") {
                  DiscuzRoute.navigate(
                    context: context,
                    shouldLogin: true,
                    fullscreenDialog: true,
                    widget: Builder(
                      builder: (context) => ReportsDelegate(
                        type: ReportType.thread,
                        thread: thread,
                      ),
                    ),
                  );
                  return;
                }

                if (result == "user") {
                  DiscuzRoute.navigate(
                      context: context,
                      shouldLogin: true,
                      widget: UserHomeDelegate(
                        user: author,
                      ));
                  return;
                }
              })
        ],
      ),
    );
  }
}

class _ThreadCardQuickActionsItem extends StatelessWidget {
  const _ThreadCardQuickActionsItem(
      {Key key,
      @required this.icon,
      @required this.onPressed,
      this.count = 0,
      this.iconSize,
      this.hideCounter = false})
      : super(key: key);

  /// icon
  final dynamic icon;

  /// onPressed
  final Function onPressed;

  /// counter
  final int count;

  /// hide counter
  final bool hideCounter;

  ///
  /// iconSize
  final double iconSize;

  @override
  Widget build(BuildContext context) => Expanded(
        child: IconButton(
          icon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DiscuzIcon(
                icon,
                size: iconSize,
                color: DiscuzApp.themeOf(context).textColor,
              ),
              const SizedBox(
                width: 4,
              ),
              hideCounter
                  ? const SizedBox()
                  : DiscuzText(
                      count.toString(),
                      fontSize: DiscuzApp.themeOf(context).smallTextSize,
                      color: DiscuzApp.themeOf(context).greyTextColor,
                      overflow: TextOverflow.ellipsis,
                    )
            ],
          ),
          onPressed: onPressed,
        ),
      );
}
