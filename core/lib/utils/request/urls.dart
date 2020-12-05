import 'package:core/utils/global.dart';

class Urls {
  /// -----------------------------------
  /// 统一配置
  ///
  static String _apiPath = '${Global.domain}/api';

  /// -----------------------------------
  /// 站点
  ///
  /// 站点信息
  static String forum = "$_apiPath/forum";

  /// 站点基本信息接口
  static String siteinfo = "$_apiPath/siteinfo";

  /// 拼接站点Logo
  /// 注意这个logo是站点默认的logo文件
  /// 当站点没有设置logo的时候,discuzAppLogo 组件将尝试缓存该图片作为app logo
  static String siteLogo = "$_apiPath/static/images/logo.png";

  /// -----------------------------------
  /// 用户
  ///

  /// 用户资料展示
  static String users = "$_apiPath/users";

  /// 上传头像接口
  /// 该接口存在拼接，在avatarPicker
  /// static String usersAvatar = "$_apiPath/users/{id}/avatar";

  /// 刷新Token
  static String usersRefreshToken = "$_apiPath/refresh-token";

  /// 用户注册
  static String usersRegister = "$_apiPath/register";

  /// 用户登录
  static String usersLogin = "$_apiPath/login";

  /// -----------------------------------
  /// 分类
  /// 查询所有分类
  static String categories = "$_apiPath/categories";

  /// -----------------------------------
  /// 金融钱包等
  /// 金融钱包相关接口
  static String usersWallerData = "$_apiPath/wallet/user";

  /// -----------------------------------
  /// 表情
  /// 拉取表情列表
  static String emoji = "$_apiPath/emoji";

  /// -----------------------------------
  /// 主题
  /// 主题相关的接口
  static String threads = "$_apiPath/threads";

  /// -----------------------------------
  /// 话题
  /// 话题相关的接口
  static String topics = "$_apiPath/topics";

  ///
  /// 收藏
  static String threadsFavorites = "$_apiPath/favorites";

  /// -----------------------------------
  /// 关注
  /// 创建关注接口
  static String follow = "$_apiPath/follow";

  /// -----------------------------------
  /// 评论
  /// 评论接口
  static String posts = "$_apiPath/posts";

  /// -----------------------------------
  /// 通知
  /// 通知接口
  static String notifications = "$_apiPath/notification";

  /// -----------------------------------
  /// 附件
  /// 附件相关
  /// 附件上传
  static String attachments = "$_apiPath/attachments";

  /// -----------------------------------
  /// 短信
  /// 发送短信
  /// 验证短信
  static String sms = "$_apiPath/sms";

  /// -----------------------------------
  /// 举报
  /// 创建举报数据 post
  /// 举报列表数据 get
  /// 批量删除举报 delete
  /// 批量修改举报 batch
  static String reports = "$_apiPath/reports";

  /// -----------------------------------
  /// 视频上传
  /// 视频上传相关的接口
  ///
  /// 取得签名
  /// 上传前，先取得签名其次在上传到腾讯云点播
  ///
  static String videoSignature = "$_apiPath/signature";

  /// 申请上传
  /// 腾讯云点播，请求UGC
  /// 所需参数
  /// signature:
  /// videoName:
  /// videoSize:
  /// videoType:
  /// 请求成功后，将返回用于上传的节点信息，包含存储区域等以及COS临时上传的签名 以及vodSessionKey
  /// 分片上传
  static String videoApplyUGC =
      "https://vod2.qcloud.com/v3/index.php?Action=ApplyUploadUGC";

  /// 确认上传
  /// CommmitUGC
  /// CommitUGC接口将返回文件真实的地址
  /// 和用于创建媒体关联的fileId
  static String videoCommitUGC =
      "https://vod2.qcloud.com/v3/index.php?Action=CommitUploadUGC";

  /// 瞎猜的用途
  /// 上传结果汇报
  /// 上传成功后，使用 videoApplyUGC，和上传文件的相关参数进行确认汇报
  ///
  /// 示例参数
  /// appId: 1400331686
  /// cosRegion: "ap-chongqing"
  /// device: "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"
  /// errCode: 0
  /// fileId: "5285890800442595308"
  /// fileName: "0bb56cc026804d1a91d6dbc47460bed2_2000_h264_1872_aac_128.mp4"
  /// fileSize: 13784875
  /// fileType: "video/mp4"
  /// platform: 3000
  /// reportId: ""
  /// reqKey: "01e61afd-8e5d-46df-bcb0-c2cd5231fc5a"
  /// reqTime: 1585645384120
  /// reqTimeCost: 6312
  /// reqType: 40001
  /// version: "1.4.8"
  /// vodSessionKey:
  static String videoUGCUploadNew =
      "https://vodreport.qcloud.com/ugcupload_new";

  ///
  /// 获取视频播放文件信息
  /// 使用form 配置中的 qcloud_vod_sub_app_id
  /// 和 视频模型的 fileID 拼接URL 获取播放文件信息
  /// videoFileInfo/qcloud_vod_sub_app_id/fileID
  static String videoPlayInfo = "https://playvideo.qcloud.com/getplayinfo/v4";

  ///
  /// github changelog
  ///
  static String changelog =
      'https://github.com/virskor/DiscuzQ/blob/master/CHANGELOG.md';
}
