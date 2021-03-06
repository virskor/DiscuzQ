import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/common/discuzCachedNetworkImage.dart';

class DiscuzImage extends StatefulWidget {
  ///
  /// 是否允许分享
  /// 允许分享的时候，要同时传入threadModel thread 否则将无法分享
  final bool enbleShare;

  ///
  /// 附件
  final AttachmentsModel attachment;

  ///
  /// 故事
  /// 关联的故事，当enable Share的时候要传入
  final ThreadModel thread;

  ///
  /// 是否是缩略图模式
  /// 否则将返回原图
  final bool isThumb;

  ///
  /// 查看原图
  /// 请求查看原图
  final Function onWantOriginalImage;

  final BorderRadius borderRadius;

  final int memCacheWidth;

  final int memCacheHeight;

  final BoxFit fit;

  const DiscuzImage({
    @required this.attachment,
    this.thread,
    this.onWantOriginalImage,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fit = BoxFit.cover,
    this.isThumb = true,
    this.borderRadius = const BorderRadius.all(const Radius.circular(5)),
    this.enbleShare = false,
  });
  @override
  _DiscuzImageState createState() => _DiscuzImageState();
}

class _DiscuzImageState extends State<DiscuzImage> {
  @override
  Widget build(BuildContext context) {
    return _buildImage(
        attachment: widget.attachment,
        context: context,
        onWantOriginalImage: widget.onWantOriginalImage);
  }

  ///
  /// 生成被缓存的图片，这个图片将被context Menu包裹
  ///
  Widget _buildImage(
      {BuildContext context,
      @required AttachmentsModel attachment,
      @required Function onWantOriginalImage}) {
    final double imageSize = (double.infinity * .3) - 4;

    return GestureDetector(
      onTap: () => onWantOriginalImage(attachment.attributes.url),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: DiscuzCachedNetworkImage(
          imageUrl: widget.isThumb
              ? attachment.attributes.thumbUrl
              : attachment.attributes.url,

          ///
          /// 请求图片时要带Referer
          fit: widget.fit,
          width: widget.isThumb ? imageSize : null,
          height: widget.isThumb ? imageSize : null,
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/errimage.png',
            width: widget.isThumb ? imageSize : null,
            height: widget.isThumb ? imageSize : null,
            fit: BoxFit.contain,
          ),
          memCacheHeight: widget.memCacheHeight,
          memCacheWidth: widget.memCacheWidth,
        ),
      ),
    );
  }
}
