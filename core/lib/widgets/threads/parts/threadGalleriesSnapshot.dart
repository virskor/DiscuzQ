import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import 'package:core/widgets/threads/threadsCacher.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/attachmentsModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/widgets/common/discuzImage.dart';
import 'package:core/views/gallery/discuzGalleryDelegate.dart';
import 'package:core/router/route.dart';

///
/// 帖子9宫格图片预览组件
///
class ThreadGalleriesSnapshot extends StatelessWidget {
  ///------------------------------
  /// threadsCacher 是用于缓存当前页面的主题数据的对象
  /// 当数据更新的时候，数据会存储到 threadsCacher
  /// threadsCacher 在页面销毁的时候，务必清空 .clear()
  ///
  final ThreadsCacher threadsCacher;

  ///
  /// 第一条post
  final PostModel firstPost;

  ///
  /// 关联的主题
  final ThreadModel thread;

  ThreadGalleriesSnapshot(
      {@required this.threadsCacher,
      @required this.firstPost,
      @required this.thread});

  @override
  Widget build(BuildContext context) {
    ///
    /// 一个图片都没有，直接返回，能省事就省事
    if (threadsCacher.attachments.length == 0) {
      return const SizedBox();
    }

    final List<dynamic> getPostImages = firstPost.relationships.images;

    /// 如果没有关联的图片，那还不是返回，不渲染
    if (getPostImages.length == 0) {
      return const SizedBox();
    }

    /// 将relationships中的数据和attachments对应，并生成attachmentsModel的数组
    final List<AttachmentsModel> attachmentsModels = [];
    getPostImages.forEach((e) {
      final int id = int.tryParse(e['id']);
      final AttachmentsModel attachment = threadsCacher.attachments
          .where((AttachmentsModel find) => find.id == id)
          .toList()[0];
      if (attachment != null) {
        attachmentsModels.add(attachment);
      }
    });

    /// 可能出现找不到 对应图片的问题
    if (attachmentsModels == null || attachmentsModels.length == 0) {
      return const SizedBox();
    }

    ///
    /// 原图所有图片Url 图集
    final List<String> originalImageUrls =
        attachmentsModels.map((e) => e.attributes.url).toList();

    return RepaintBoundary(
      child: NineGridView(
        padding: const EdgeInsets.all(2),
        space: 3,
        type: NineGridType.normal,

        /// normal only
        itemCount: attachmentsModels.length >= 8 ? 9 : attachmentsModels.length,
        itemBuilder: (BuildContext context, int index) {
          if (index > 8 || index > attachmentsModels.length) {
            return const SizedBox();
          }

          if (attachmentsModels[index] == null) {
            return const SizedBox();
          }

          return DiscuzImage(
              attachment: attachmentsModels[index],
              enbleShare: true,
              thread: thread,
              onWantOriginalImage: (String targetUrl) {
                /// 显示原图图集
                /// targetUrl是用户点击到的要查看的图片
                /// 调整数组，将targetUrl置于第一个，然后传入图集组件
                originalImageUrls.remove(targetUrl);
                originalImageUrls.insert(0, targetUrl);
                return DiscuzRoute.navigate(
                    fullscreenDialog: true,
                    context: context,
                    widget: DiscuzGalleryDelegate(gallery: originalImageUrls));
              });
        },
      ),
    );
  }
}
