import 'package:cached_network_image/cached_network_image.dart';
import 'package:discuzq/widgets/posts/postLikeButton.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/utils/dateUtil.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/users/userLink.dart';

class PostFloorCard extends StatelessWidget {
  ///
  /// 关联的用户
  final PostModel post;

  ///
  ///
  final ThreadsCacher threadsCacher;

  const PostFloorCard({@required this.post, @required this.threadsCacher});

  @override
  Widget build(BuildContext context) {
    ///
    /// post.relationships.user会存在为null的情况，这是因为数据中存在fistPost,但这不是一个回复
    ///
    if (post.relationships.user == null) {
      return SizedBox();
    }

    final List<UserModel> user = threadsCacher.users
        .where((UserModel u) =>
            u.id == int.tryParse(post.relationships.user['data']['id']))
        .toList();

    final List<UserModel> replyUser = threadsCacher.users
        .where((UserModel u) => u.id == post.attributes.replyUserID)
        .toList();

    /// 遍历图片
    final List<dynamic> getPostImages = post.relationships.images;
    List<AttachmentsModel> attachmentsModels = [];
    if (getPostImages.length > 0) {
      getPostImages.forEach((e) {
        final int id = int.tryParse(e['id']);
        final AttachmentsModel attachment = threadsCacher.attachments
            .where((AttachmentsModel find) => find.id == id)
            .toList()[0];
        if (attachment != null) {
          attachmentsModels.add(attachment);
        }
      });
    }

    ///
    /// 找不到相关用户
    if (user.length == 0 || user == null) {
      return SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ///
          /// 用户顶部信息
          _buildHeader(
              context: context,
              user: user[0],
              replyUser: replyUser == null || replyUser.length == 0
                  ? null
                  : replyUser[0]),

          const SizedBox(height: 10),

          ///
          /// 显示评论的内容
          HtmlRender(
            html: post.attributes.contentHtml,
          ),

          /// 显示图片
          ...attachmentsModels
              .map((AttachmentsModel a) => Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: CachedNetworkImage(
                      imageUrl: a.attributes.url,
                    ),
                  ))
              .toList(),

          ///
          /// 显示评论的附件
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///
  /// 用户顶部
  Widget _buildHeader(
          {BuildContext context,
          @required UserModel user,
          UserModel replyUser}) =>
      Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => DiscuzRoute.open(
                context: context,
                shouldLogin: true,
                widget: UserHomeDelegate(
                  user: user,
                )),
            child: DiscuzAvatar(
              size: 35,
              url: user.avatarUrl,
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
                  Row(children: <Widget>[
                    DiscuzText(
                      user.username,
                      fontWeight: FontWeight.bold,
                    ),

                    /// 显示回复给谁
                    replyUser == null
                        ? const SizedBox()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(width: 5),
                              DiscuzText(
                                '回复',
                                color: DiscuzApp.themeOf(context).greyTextColor,
                              ),
                              UserLink(user: replyUser)
                            ],
                          ),
                  ]),
                  DiscuzText(
                    ///
                    /// 格式化时间
                    DateUtil.formatDate(
                        DateTime.parse(post.attributes.createdAt),
                        format: "yyyy-MM-dd HH:mm"),
                    color: DiscuzApp.themeOf(context).greyTextColor,
                    fontSize: DiscuzApp.themeOf(context).smallTextSize,
                  )
                ],
              ),

              /// pop menu
            ),
          ),

          ///
          /// 显示点赞按钮
          ///
          PostLikeButton(
            post: post,
            size: 20,
          )
        ],
      );
}
