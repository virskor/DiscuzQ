import 'dart:async';

import 'package:flutter/material.dart';

const int maxLiveNum = 35;

class DiscuzImageCacheManagement {
  factory DiscuzImageCacheManagement() => _getInstance();
  static DiscuzImageCacheManagement get instance => _getInstance();
  static DiscuzImageCacheManagement _instance;
  DiscuzImageCacheManagement._internal() {
    // initial
  }

  static DiscuzImageCacheManagement _getInstance() {
    if (_instance == null) {
      _instance = DiscuzImageCacheManagement._internal();
    }
    return _instance;
  }

  Timer _timer;

  /// 优化图片内存管理
  void checkMemory() {
    const period = const Duration(seconds: 2);

    _timer = Timer.periodic(period, (timer) {
      ImageCache _imageCache = PaintingBinding.instance.imageCache;
      if (_imageCache.liveImageCount < maxLiveNum) {
        return;
      }

      debugPrint(
          "clear cached live image ------->${_imageCache.liveImageCount.toString()}");

      //_imageCache.clear();
      _imageCache.clearLiveImages();
    });
  }

  /// 结束
  void dispose() {
    if (_timer == null) {
      return;
    }
    _timer.cancel();
  }
}
