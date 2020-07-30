import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/models/forumModel.dart';
import 'package:discuzq/utils/debouncer.dart';

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

  ///
  /// 已经登录的用户
  ///
  UserModel _user;
  UserModel get user => _user;
  void updateUser(UserModel user) {
    _user = user;
    _noticeRebuild();
  }

  ///
  /// 本地设置项
  ///
  dynamic _appConf;
  get appConf => _appConf;

  ///
  /// 初始化配置状态
  ///
  void initAppConf(dynamic conf) {
    if (conf == null) {
      return;
    }
    _appConf = conf;
    _noticeRebuild();
  }

  ///
  /// 使用key 更新配置状态
  ///
  void updateAppConfByKeyName(String key, dynamic val) {
    _appConf[key] = val;
    _noticeRebuild();
  }

  /// 通知组件重构

  void _noticeRebuild() {
    _debouncer.run(() {
      notifyListeners();
    });
  }
}
