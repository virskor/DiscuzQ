import 'package:core/models/emojiModel.dart';
import 'package:core/widgets/emoji/emojiSync.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Emoji {
  ///
  /// 使用 span 获取一个表情的image provider
  /// 如 可爱 :keai:
  static ImageProvider getBySpan({@required String span}) {
    /// 取得要用来渲染的emoji
    final List<EmojiModel> emoji = EmojiSync()
        .cachedEmojis
        .where((EmojiModel emj) => emj.attributes.code == span)
        .toList();

    if (emoji.length == 0) {
      return AssetImage("assets/images/errimage.png");
    }

    return CachedNetworkImageProvider(emoji[0].attributes.url);
  }
}
