import 'package:discuzq/widgets/posts/postLikeButton.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/postModel.dart';

class DiscuzPlayerRightSider extends StatefulWidget {
  ///
  /// 关联的帖子或评论
  final PostModel post;

  DiscuzPlayerRightSider({this.post});

  @override
  _DiscuzPlayerRightSiderState createState() => _DiscuzPlayerRightSiderState();
}

class _DiscuzPlayerRightSiderState extends State<DiscuzPlayerRightSider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Column(
        children: <Widget>[
          PostLikeButton(
            post: widget.post,
            size: 40,
          )
        ],
      ),
    );
  }
}
