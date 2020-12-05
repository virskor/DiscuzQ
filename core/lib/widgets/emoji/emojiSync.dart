import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/models/emojiModel.dart';
import 'package:core/utils/StringHelper.dart';
import 'package:core/utils/localstorage.dart';

///
/// localstorage key
///
const String _localStorageKey = 'emoji';

///
/// 将服务端的Emoji 同步到本地
/// 单例 一次读取，常驻内存多处调用
///
class EmojiSync {

  factory EmojiSync() => _getInstance();
  static EmojiSync get instance => _getInstance();
  static EmojiSync _instance;
  EmojiSync._internal() {
    // init
  }

  static EmojiSync _getInstance() {
    if (_instance == null) {
      _instance = EmojiSync._internal();
    }
    return _instance;
  }

  ///
  /// 暂存的表情列表
  List<EmojiModel> cachedEmojis = [];

  ///
  /// 获取所有的Emoji并生成
  /// context 非必选
  /// doNotGetFromLocal 默认false 即有缓存则取缓存
  Future<List<EmojiModel>> getEmojis(
      {BuildContext context, bool doNotGetFromLocal = false}) async {
    ///
    /// 内存中的表情数据
    if (cachedEmojis.length > 0) {
      return Future.value(cachedEmojis);
    }

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
        ///
        /// 缓存以供直接读取
        cachedEmojis = emojis;
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

    /// 缓存起来
    cachedEmojis = emojis;

    ///
    /// 将emojis列表缓存到本地
    DiscuzLocalStorage.setString(_localStorageKey, jsonEncode(emojiList));

    return Future.value(emojis);
  }
}
