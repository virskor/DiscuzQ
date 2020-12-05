import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/models/threadModel.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/widgets/share/shareNative.dart';
import 'package:core/models/postModel.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/api/threads.dart';
import 'package:core/router/route.dart';
import 'package:core/views/reports/reportsDelegate.dart';
import 'package:core/widgets/common/discuzDialog.dart';

class PostDetBot extends StatefulWidget {
  ///
  /// 要显示的主题
  ///
  final ThreadModel thread;

  ///
  /// 首贴
  final PostModel post;

  PostDetBot({@required this.thread, @required this.post});

  @override
  _PostDetBotState createState() => _PostDetBotState();
}

class _PostDetBotState extends State<PostDetBot> {
  /// states
  ///
  /// _collected
  /// 我是否刚才点击了收藏按钮
  /// 默认情况下要为null， 表示本次用户从未点击过，使用上次的状态

  bool _collected;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DiscuzText(
            ///
            /// 由于 postCount 包含 fristpost 所以要进行减除
            "${(widget.thread.attributes.postCount - 1).toString()}回复",
            color: DiscuzApp.themeOf(context).greyTextColor,
          ),
          Row(
            children: <Widget>[
              DiscuzLink(
                  label: '举报',
                  onTap: () => DiscuzRoute.navigate(
                        context: context,
                        shouldLogin: true,
                        fullscreenDialog: true,
                        widget: Builder(
                          builder: (context) => ReportsDelegate(
                              type: ReportType.thread, thread: widget.thread),
                        ),
                      )),

              DiscuzLink(
                label: '分享',
                onTap: () => ShareNative.shareThread(thread: widget.thread),
              ),
              DiscuzLink(
                label: _collectionButtonLabel(),
                onTap: _requestFavorite,
              ),

              ///
              /// 删除帖子
              widget.post.attributes.canEdit
                  ? DiscuzLink(
                      label: '删除',
                      onTap: () async {
                        await DiscuzDialog.confirm(
                            context: context,
                            title: '提示',
                            message: '确定删除吗？',
                            onConfirm: () async {
                              ///
                              /// 执行删除
                              ///
                              final bool result =
                                  await ThreadsAPI(context: context)
                                      .delete(thread: widget.thread);
                              if (result && Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                      },
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  ///
  /// 收藏按钮的标题
  String _collectionButtonLabel() {
    ///
    /// 如果_collected 不为Null 证明用户点击过收藏按钮
    if (_collected != null) {
      return _collected ? '已收藏' : '收藏';
    }
    return widget.thread.attributes.isFavorite ? '已收藏' : '收藏';
  }

  ///
  /// 执行收藏，或者取消收藏
  Future<void> _requestFavorite() async {
    if (widget.thread.relationships == null) {
      return;
    }

    /// 判断是收藏还是取消收藏
    bool isFavorite = widget.thread.attributes.isFavorite ? false : true;
    if (_collected != null) {
      isFavorite = !isFavorite;

      /// 取反
    }

    final dynamic data = {
      "data": {
        "type": "threads",
        "attributes": {
          "isFavorite": isFavorite,
        },
      },
      "relationships": {"category": widget.thread.relationships.category}
    };

    final Function close = DiscuzToast.loading(context: context);

    try {
      Response resp = await Request(context: context).patch(
          url: '${Urls.threads}/${widget.thread.id.toString()}', data: data);

      close();

      if (resp == null) {
        return;
      }

      setState(() {
        _collected = isFavorite;
      });
    } catch (e) {
      close();
      throw e;
    }
  }
}
