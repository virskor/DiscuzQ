import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

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
import 'package:discuzq/widgets/threads/threadsCacher.dart';
import 'package:discuzq/widgets/users/userLink.dart';
import 'package:discuzq/widgets/posts/postLikeButton.dart';
import 'package:discuzq/widgets/common/discuzImage.dart';
import 'package:discuzq/views/gallery/discuzGalleryDelegate.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzDialog.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/api/postsAPI.dart';
import 'package:discuzq/widgets/editor/discuzEditorHelper.dart';
import 'package:discuzq/widgets/editor/discuzEditorRequestResult.dart';

class PostFloorCard extends StatelessWidget {
  ///
  /// 关联的用户
  final PostModel post;

  ///
  ///
  final ThreadsCacher threadsCacher;

  ///
  /// 主题模型
  final ThreadModel thread;

  ///
  /// 被删除
  ///
  final Function onDelete;

  const PostFloorCard(
      {@required this.post,
      @required this.threadsCacher,
      @required this.thread,
      this.onDelete});

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
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: DiscuzApp.themeOf(context).backgroundColor,
      ),
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
                    child: DiscuzImage(
                        attachment: a,
                        enbleShare: true,
                        isThumb: false,
                        thread: thread,
                        onWantOriginalImage: (String targetUrl) {
                          /// 显示原图图集
                          /// targetUrl是用户点击到的要查看的图片
                          /// 调整数组，将targetUrl置于第一个，然后传入图集组件
                          ///
                          /// 原图所有图片Url 图集
                          final List<String> originalImageUrls =
                              attachmentsModels
                                  .map((e) => e.attributes.url)
                                  .toList();

                          /// 显示原图图集
                          /// targetUrl是用户点击到的要查看的图片
                          /// 调整数组，将targetUrl置于第一个，然后传入图集组件
                          originalImageUrls.remove(a.attributes.url);
                          originalImageUrls.insert(0, a.attributes.url);
                          return showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DiscuzGalleryDelegate(
                                      gallery: originalImageUrls));
                        }),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
              url: user.attributes.avatarUrl,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    DiscuzText(
                      user.attributes.username,
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
                        DateTime.parse(post.attributes.createdAt).toLocal(),
                        format: "yyyy-MM-dd HH:mm"),
                    color: DiscuzApp.themeOf(context).greyTextColor,
                    fontSize: DiscuzApp.themeOf(context).smallTextSize,
                  )
                ],
              ),

              /// pop menu
            ),
          ),

          /// 是否有删除不编辑权限
          post.attributes.canEdit
              ? IconButton(
                  padding: const EdgeInsets.only(top: 2),
                  icon: DiscuzIcon(
                    SFSymbols.trash,
                    size: 20,
                  ),
                  onPressed: () => DiscuzDialog.confirm(
                      context: context,
                      title: '提示',
                      message: '是否删除评论？',
                      onConfirm: () async {
                        final Function close =
                            DiscuzToast.loading(context: context);
                        final bool result = await PostsAPI(context: context)
                            .delete(postID: post.id);
                        close();
                        if (result && onDelete != null) {
                          /// 删除成功，隐藏该项目
                          onDelete();
                        }
                      }),
                )
              : const SizedBox(),

          ///
          /// 显示点赞按钮
          ///
          PostLikeButton(
            post: post,
            size: 20,
          ),

          ///
          /// 评论按钮
          IconButton(
            icon: DiscuzIcon(
              SFSymbols.bubble_left_bubble_right,
              size: 20,
              color: DiscuzApp.themeOf(context).textColor,
            ),
            onPressed: () async {
              final DiscuzEditorRequestResult res =
                  await DiscuzEditorHelper(context: context)
                      .reply(post: post, thread: thread);
              if (res != null) {
                threadsCacher.posts = res.posts;
                threadsCacher.users = res.users;
                DiscuzToast.success(context: context, message: '回复成功');
              }
            },
          )
        ],
      );
}
