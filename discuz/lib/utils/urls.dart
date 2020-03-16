import 'package:discuzq/utils/global.dart';

class Urls {
  /// -----------------------------------
  /// 统一配置
  ///
  static const String _apiPath = '${Global.domain}/api';

  /// -----------------------------------
  /// 站点
  ///
  /// 站点信息
  static const String forum = "$_apiPath/forum";

  /// 站点基本信息接口
  static const String siteinfo = "$_apiPath/siteinfo";

  /// -----------------------------------
  /// 用户
  ///
  /// 上传头像接口
  static const String usersAvatar = "$_apiPath/users/{id}/avatar";

  /// 用户资料展示
  static const String usersData = "$_apiPath/users/{id}";

  /// 刷新Token
  static const String usersRefreshToken = "$_apiPath/users/refresh-token";

  /// 用户注册
  static const String usersRegister = "$_apiPath/users/register";

  /// 用户登录
  static const String usersLogin = "$_apiPath/users/login";

  /// -----------------------------------
  /// 分类
  /// 查询所有分类
  static const String categories = "$_apiPath/categories";
}
