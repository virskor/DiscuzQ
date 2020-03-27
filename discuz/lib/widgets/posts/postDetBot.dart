import 'package:dio/dio.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/share/shareNative.dart';

class PostDetBot extends StatefulWidget {
  ///
  /// 要显示的主题
  ///
  final ThreadModel thread;

  PostDetBot({@required this.thread});

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
            "${widget.thread.attributes.postCount.toString()}回复",
            color: DiscuzApp.themeOf(context).greyTextColor,
          ),
          Row(
            children: <Widget>[
              DiscuzLink(
                label: '分享',
                onTap: () => ShareNative.shareThread(thread: widget.thread),
              ),
              DiscuzLink(
                label: _collectionButtonLabel(),
                onTap: _requestFavorite,
              ),
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
    Response resp = await Request(context: context)
        .patch(url: '${Urls.threads}/${widget.thread.id.toString()}', data: data);
    close();
    if (resp == null) {
      return;
    }

    setState(() {
      _collected = isFavorite;
    });
  }
}
