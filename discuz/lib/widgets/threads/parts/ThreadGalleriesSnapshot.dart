import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/attachmentsModel.dart';

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

  ThreadGalleriesSnapshot(
      {@required this.threadsCacher, @required this.firstPost});

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
    if (attachmentsModels.length == 0) {
      return const SizedBox();
    }

    final double imageSize = (MediaQuery.of(context).size.width * .3) - 4;

    return RepaintBoundary(
      child: Container(
        child: Wrap(
          children: attachmentsModels

              /// inde 0-8 最对只显示9张，形成9宫格
              .map((e) => attachmentsModels.indexOf(e) > 8
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(2),
                      child: CachedNetworkImage(
                        imageUrl: e.attributes.thumbUrl,
                        fit: BoxFit.cover,
                        width: imageSize,
                        height: imageSize,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/errimage.png',
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ))
              .toList(),
        ),
      ),
    );
  }
}
