import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/models/forumModel.dart';

class AppState extends StateModel {
  ///
  /// forum 站点信息
  ///
  ForumModel _forum;
  get forum => _forum;
  void updateForum(ForumModel forum) {
    _forum = forum;
    notifyListeners();
  }

  ///
  /// 用户当前悬停的分类
  CategoryModel _focusedCategory;
  get focusedCategory => _focusedCategory;
  void updateFocusedCategories(CategoryModel cat) {
    _focusedCategory = cat;
    notifyListeners();
  }

  ///
  /// categories 分类列表状态
  ///
  List<CategoryModel> _categories;
  get categories => _categories;
  void updateCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  ///
  /// 已经登录的用户
  ///
  UserModel _user;
  get user => _user;
  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
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
    notifyListeners();
  }

  ///
  /// 使用key 更新配置状态
  ///
  void updateAppConfByKeyName(String key, dynamic val) {
    _appConf[key] = val;
    notifyListeners();
  }
}
