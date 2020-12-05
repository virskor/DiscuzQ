import 'package:flutter/foundation.dart';

import 'package:core/models/categoryModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class CategoriesProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  /// forum 站点信息
  ///
  List<CategoryModel> _categories = List();
  get categories => _categories;

  void updateCategories(List<CategoryModel> cats) {
    _categories = cats;
    notifyListeners();
  }
}
