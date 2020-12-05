import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/models/categoryModel.dart';
import 'package:core/utils/localstorage.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';

const String _localCategoriesStorageKey = 'categories';

class DiscuzCategories {
  final BuildContext context;

  DiscuzCategories({@required this.context});

  /// 取得分类列表
  /// 优先从本地的缓存取得分类
  /// 如果本地没有分类在从接口请求
  /// 返回构造的分类列表
  Future<List<CategoryModel>> getCategories() async {
    ///
    /// 先从本地取得供APP快速启动，接口请求的数据供下次使用
    final String localCategoriesData =
        await DiscuzLocalStorage.getString(_localCategoriesStorageKey);
    if (localCategoriesData == null) {
      /// 从接口取得
      final List<CategoryModel> cats = await requestCategories();
      return Future.value(cats);
    }

    ///
    /// 从本地取得上次缓存的数据
    ///
    final List<dynamic> decodeLocalCategoriesData =
        jsonDecode(localCategoriesData);

    /// 增加一个全部并转化所有分类到模型
    List<CategoryModel> categories = decodeLocalCategoriesData
        .map<CategoryModel>((it) => CategoryModel.fromMap(maps: it))
        .toList();

    return Future.value(categories);
  }

  ///
  /// 将从接口取得分类配置
  /// request Categories Data
  ///
  Future<List<CategoryModel>> requestCategories() async {
    Response resp =
        await Request(context: context).getUrl(url: Urls.categories);

    if (resp == null) {
      return Future.value(const []);
    }

    List<dynamic> originalCategories = resp.data['data'] ?? [];
    if (originalCategories.length > 0) {
      /// 存储分类到本地供下次使用
      DiscuzLocalStorage.setString(
          _localCategoriesStorageKey, jsonEncode(originalCategories));
    }

    /// 增加一个全部并转化所有分类到模型
    List<CategoryModel> categories = originalCategories
        .map<CategoryModel>((it) => CategoryModel.fromMap(maps: it))
        .toList();

    return Future.value(categories);
  }
}
