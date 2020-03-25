import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:discuzq/widgets/common/discuzContextMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

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

    ///
    /// 原图所有图片Url 图集
    final List<String> originalImageUrls =
        attachmentsModels.map((e) => e.attributes.url).toList();

    return RepaintBoundary(
      child: Container(
        child: Wrap(
          children: attachmentsModels

              /// inde 0-8 最对只显示9张，形成9宫格
              .map((e) => attachmentsModels.indexOf(e) > 8
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(2),
                      child: _buildImage(
                          context: context,
                          attachment: e,
                          onWantOriginalImage: (String targetUrl) {
                            /// 显示原图图集
                            /// targetUrl是用户点击到的要查看的图片
                            /// 调整数组，将targetUrl置于第一个，然后传入图集组件 
                            print(originalImageUrls.toString());
                          }),
                    ))
              .toList(),
        ),
      ),
    );
  }

  ///
  /// 渲染图片
  Widget _buildImage(
      {BuildContext context,
      @required AttachmentsModel attachment,
      @required Function onWantOriginalImage}) {
    final double imageSize = (MediaQuery.of(context).size.width * .3) - 4;

    return CupertinoContextMenu(
      previewBuilder:
          (BuildContext context, Animation<double> animation, Widget child) {
        return FittedBox(
          fit: BoxFit.cover,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4 * animation.value),
            child: child,
          ),
        );
      },
      actions: <Widget>[
        DiscuzContextMenuAction(
          child: const Text('查看大图'),
          isDefaultAction: false,
          trailingIcon: SFSymbols.viewfinder_circle,
          onPressed: () {
            if (onWantOriginalImage != null) {
              onWantOriginalImage(attachment.attributes.url);
            }
            Navigator.pop(context);
          },
        ),
        DiscuzContextMenuAction(
          child: const Text('保存原图'),
          trailingIcon: SFSymbols.tray_arrow_down,
          onPressed: () async {
            final Response response = await Dio().get(attachment.attributes.url,
                options: Options(responseType: ResponseType.bytes));
            final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(response.data));
            if (result) {
              DiscuzToast.success(context: context, message: '保存成功');
              Navigator.pop(context);
              return;
            }
            DiscuzToast.failed(context: context, message: '保存失败');
            Navigator.pop(context);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => onWantOriginalImage(attachment.attributes.url),
        child: CachedNetworkImage(
          imageUrl: attachment.attributes.thumbUrl,
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
      ),
    );
  }
}
