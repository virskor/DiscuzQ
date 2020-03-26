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

  /// 用户资料展示
  static const String users = "$_apiPath/users";

  /// 上传头像接口
  /// 该接口存在拼接，在avatarPicker
  /// static const String usersAvatar = "$_apiPath/users/{id}/avatar";

  /// 刷新Token
  static const String usersRefreshToken = "$_apiPath/refresh-token";

  /// 用户注册
  static const String usersRegister = "$_apiPath/register";

  /// 用户登录
  static const String usersLogin = "$_apiPath/login";

  /// -----------------------------------
  /// 分类
  /// 查询所有分类
  static const String categories = "$_apiPath/categories";

  /// -----------------------------------
  /// 金融钱包等
  /// 金融钱包相关接口
  static const String usersWallerData = "$_apiPath/wallet/user";

  /// -----------------------------------
  /// 表情
  /// 拉取表情列表
  static const String emoji = "$_apiPath/api/emoji";

  /// -----------------------------------
  /// 主题
  /// 主题相关的接口
  static const String threads = "$_apiPath/threads";
  ///
  /// 收藏
  static const String threadsFavorites = "$_apiPath/favorites";

  /// -----------------------------------
  /// 关注
  /// 创建关注接口
  static const String follow = "$_apiPath/follow";

  /// -----------------------------------
  /// 评论
  /// 评论接口
  static const String posts = "$_apiPath/posts";
}
