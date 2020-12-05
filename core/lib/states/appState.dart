import 'package:core/models/categoryModel.dart';
import 'package:core/states/scopedState.dart';
import 'package:core/utils/debouncer.dart';

/*
 * 
 * 
 * 
 * 
 * 
 * scoped model 中的状态将在近期逐渐被清除
 * 
 * 异步providers
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
final Debouncer _debouncer = Debouncer(milliseconds: 400);

class AppState extends StateModel {
  ///
  /// categories 分类列表状态
  ///
  List<CategoryModel> _categories;
  get categories => _categories;
  void updateCategories(List<CategoryModel> categories) {
    _categories = categories;
    if (_categories != null) {
      return;
    }
    _noticeRebuild();
  }
  
  /// 通知组件重构

  void _noticeRebuild() {
    _debouncer.run(() {
      notifyListeners();
    });
  }
}
