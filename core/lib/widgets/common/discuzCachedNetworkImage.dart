import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/global.dart';
import 'package:flutter/material.dart';

class DiscuzCachedNetworkImage extends StatelessWidget {
  ///
  /// 图片的Uri
  ///
  final String imageUrl;

  ///
  /// BoxFit
  ///
  final BoxFit fit;

  ///
  /// 宽度
  final double width;

  ///
  /// 长度
  ///
  final double height;

  ///
  /// 加载错误
  ///
  final Function(BuildContext, String, Object) errorWidget;

  ///
  /// 渐入周期
  ///
  final Duration fadeInDuration;

  ///
  /// 颜色
  /// 
  final Color color;

  const DiscuzCachedNetworkImage(
      {@required this.imageUrl,
      this.fit = BoxFit.cover,
      this.errorWidget,
      this.width,
      this.fadeInDuration = const Duration(milliseconds: 270),
      this.color,
      this.height});

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: {"Referer": Global.domain},
        fit: fit,
        height: height,
        width: width,
        fadeInDuration: fadeInDuration,
        color: color,
        errorWidget: errorWidget,
      );
}
