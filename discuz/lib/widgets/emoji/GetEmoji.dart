import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/models/emojiModel.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/utils/localstorage.dart';

class GetEmoji {
  static const String _localStorageKey = 'emoji';

  ///
  /// 获取所有的Emoji并生成
  /// context 非必选
  /// doNotGetFromLocal 默认false 即有缓存则取缓存
  static Future<List<EmojiModel>> getEmojis(
      {BuildContext context, bool doNotGetFromLocal = false}) async {
    
    ///
    /// 如果本地缓存了数据，则会从本地取出减少接口请求
    /// 如果doNotGetFromLocal则强制从接口获取
    /// 
    if (!doNotGetFromLocal) {
      //// 先从本地缓存读取
      final String localEmojis =
          await DiscuzLocalStorage.getString(_localStorageKey);
      if (!StringHelper.isEmpty(string: localEmojis)) {
        final List<dynamic> emojiList = jsonDecode(localEmojis);

        final List<EmojiModel> emojis =
            emojiList.map((el) => EmojiModel.fromMap(maps: el)).toList();
        return Future.value(emojis);
      }
    }

    ///
    /// 请求接口的表情列表
    Response resp = await Request(context: context).getUrl(url: Urls.emoji);
    if (resp == null) {
      return Future.value(null);
    }

    final List<dynamic> emojiList = resp.data['data'] ?? [];
    final List<EmojiModel> emojis =
        emojiList.map((el) => EmojiModel.fromMap(maps: el)).toList();

    ///
    /// 将emojis列表缓存到本地
    DiscuzLocalStorage.setString(_localStorageKey, jsonEncode(emojiList));

    return Future.value(emojis);
  }
}
