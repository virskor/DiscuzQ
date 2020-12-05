import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'package:core/models/postModel.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/utils/device.dart';
import 'package:core/models/userModel.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/providers/userProvider.dart';

///
/// post（帖子，评论点赞组件）
///
class PostLikeButton extends StatefulWidget {
  ///
  /// 帖子
  final PostModel post;

  ///
  /// 按钮大小
  ///
  final double size;

  PostLikeButton({this.post, this.size = 20});
  @override
  _PostLikeButtonState createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<PostLikeButton> {
  @override
  Widget build(BuildContext context) =>Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider user, Widget child)=> LikeButton(
        padding: const EdgeInsets.all(0),
        isLiked: _iLikedIt(user: user.user),
        onTap: _onLikeButtonTapped,
        size: widget.size,
        likeCount: widget.post.attributes.likeCount,
        likeBuilder: (bool isLiked) => DiscuzIcon(
          0xe608,
          color: isLiked
              ? Colors.pinkAccent
              : DiscuzApp.themeOf(context).greyTextColor,
          size: widget.size,
        ),
      ));

  ///
  /// 用户点赞
  Future<bool> _onLikeButtonTapped(isLike) async {
    /// 震动
    FlutterDevice.emitVibration();

    final dynamic data = {
      "data": {
        "type": "posts",
        "attributes": {
          "isLiked": !isLike,
        }
      }
    };

    Response resp = await Request(context: context)
        .patch(url: "${Urls.posts}/${widget.post.id.toString()}", data: data);
    if (resp == null) {
      return Future.value(isLike);
    }

    return Future.value(!isLike);
  }

  ///
  /// 我是否历史点赞过
  ///
  bool _iLikedIt({@required UserModel user}) {

    ///
    /// 没有登录，也就不存在点赞的可能
    if (user == null) {
      return false;
    }

    if (widget.post.relationships == null ||
        widget.post.relationships.likedUsers.length == 0) {
      return false;
    }

    final List<dynamic> users = widget.post.relationships.likedUsers
        .where((u) => user.attributes.id == int.tryParse(u['id']))
        .toList();
    return users == null || users.length == 0 ? false : true;
  }
}
