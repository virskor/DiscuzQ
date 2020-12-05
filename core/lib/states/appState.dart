import 'package:core/models/categoryModel.dart';
import 'package:core/states/scopedState.dart';
import 'package:core/models/forumModel.dart';
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
  /// forum 站点信息
  ///
  ForumModel _forum;
  ForumModel get forum => _forum;
  void updateForum(ForumModel forum, {bool prevent = false}) {
    _forum = forum;
    if (prevent) {
      return;
    }
    _noticeRebuild();
  }

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
