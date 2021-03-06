import 'package:flutter/foundation.dart';

import 'package:discuzq/models/categoryModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class CategoriesProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  /// forum 站点信息
  ///
  List<CategoryModel> _categories = List();
  List<CategoryModel> get categories => _categories;

  /// 分类列表中将不包含我的
  List<CategoryModel> get forumDelegateCategories =>
      _categories.where((e) => e.attributes.name != "我的").take(6).toList();

  /// fake secondary tab
  List<String> get _fakeSecondaryTab => _categories
      .where((e) => e.attributes.name != "我的")
      .map((e) => e.attributes.description)
      .toSet()
      .toList();
  List<CategoryModel> get exploreCats => _categories
      .where((e) => e.attributes.name != "我的")
      .toList();
  
  List<String> get fakeSecondaryTab => ['搜索', ..._fakeSecondaryTab];

  void updateCategories(List<CategoryModel> cats) {
    _categories = cats;
    notifyListeners();
  }
}
