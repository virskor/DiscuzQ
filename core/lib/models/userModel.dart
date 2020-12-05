import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:core/models/typeUnreadNotificationsModel.dart';
import 'package:core/models/relationShipsModel.dart';

///
/// 评论模型
class UserModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 主题类型
  ///
  final int type;

  ///
  /// attributes
  /// 评论数据
  final UserAttributesModelModel attributes;

  ///
  /// relationships
  /// 关联数据
  final RelationshipsModel relationships;

  const UserModel(
      {this.id = 0, this.type = 0, this.attributes, this.relationships});

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    ///
    /// 返回转化的分类模型
    return UserModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] == null
            ? 0
            : data['type'].runtimeType == String
                ? int.tryParse(data['type'])
                : data['type'],
        relationships: data['relationships'] == null
            ? const RelationshipsModel()
            : RelationshipsModel.fromMap(maps: data['relationships']),
        attributes: data['attributes'] == null
            ? const UserAttributesModelModel()
            : UserAttributesModelModel.fromMap(maps: data['attributes']));
  }

  static UserModel copyWith({
    @required UserModel userModel,
    String username,
    int follow,
    int fansCount,
    String mobile,
    String avatarUrl,
  }) {
    final UserAttributesModelModel attributes =
        UserAttributesModelModel.copyWith(
            attributes: userModel.attributes,
            username: username,
            follow: follow,
            mobile: mobile,
            avatarUrl: avatarUrl,
            fansCount: fansCount);
    return UserModel(
        id: userModel.id, type: userModel.type, attributes: attributes);
  }
}

///
/// 值得提醒，UserModel 并不包含完整的用户信息，如分组，等
/// 如果需要使用那些 数据的时候 应该使用 UserFullModel,他将包含更多信息和一个userModel
/// 但通常情况下直接用UserModel就可以了
class UserAttributesModelModel {
  ///
  /// id
  /// 用户的id
  ///
  final int id;

  ///
  /// username
  /// 用户名
  final String username;

  ///
  /// mobile
  /// 手机号(脱敏)
  final String mobile;

  ///
  /// avatarUrl
  /// 头像地址
  ///
  final String avatarUrl;

  ///
  /// threadCount
  /// 主题数
  final int threadCount;

  ///
  /// followCount
  /// 关注数量
  ///
  final int followCount;

  ///
  /// fansCount
  /// 粉丝数量
  ///
  final int fansCount;

  /// likedCount
  /// 获得点赞
  ///
  final int likedCount;

  ///
  /// follow
  /// 关注状态
  /// 关注状态 0：未关注 1：已关注 2：互相关注
  ///
  final int follow;

  ///
  /// status
  /// 状态
  ///
  final int status;

  ///
  /// loginAt
  /// 登录于
  ///
  final String loginAt;

  ///
  /// joinedAt
  /// 注册时间
  ///
  final String joinedAt;

  ///
  /// expiredAt
  /// 到期时间
  ///
  final String expiredAt;

  ///
  /// createdAt
  /// 创建时间
  ///
  final String createdAt;

  ///
  /// updatedAt
  /// 修改时间
  ///
  final String updatedAt;

  ///
  /// canEdit
  /// 是否可以编辑
  ///
  final bool canEdit;

  ///
  /// canDelete
  /// 是否可以删除
  ///
  final bool canDelete;

  ///
  /// canWalletPay
  /// 是否可以用钱包支付
  ///
  final bool canWalletPay;

  ///
  /// registerReason
  /// 注册理由
  ///
  final String registerReason;

  ///
  /// banReason
  /// 禁用理由
  ///
  final String banReason;

  ///
  /// originalMobile
  /// 完整的手机号
  ///
  final String originalMobile;

  ///
  /// mobileConfirmed
  /// 手机号是否确认了
  ///
  final bool mobileConfirmed;

  ///
  /// registerIP
  /// 注册时的IP
  ///
  final String registerIp;

  ///
  /// lastLoginIp
  /// 最后登录的IP
  ///
  final String lastLoginIp;

  ///
  /// identity
  /// 注册理由
  ///
  final String identity;

  ///
  /// realname
  /// 真实姓名
  ///
  final String realname;

  ///
  /// signature
  /// 个人签名
  final String signature;

  ///
  /// walletBalance
  /// 钱包余额
  ///
  final String walletBalance;

  ///
  /// paid
  /// 是否支付
  ///
  final bool paid;

  ///
  /// payTime
  /// 支付时间
  ///
  final String payTime;

  ///
  /// unreadNotifications
  /// 未读消息数
  ///
  final int unreadNotifications;

  /// usernameBout
  /// 用户名修改了几次
  /// usernameBout == 0 可以修改
  /// usernameBout >=1  不可以修改
  final int usernameBout;

  /// 是否可以编辑用户名
  final bool canEditUsername;

  /// hasPassword
  /// 是否设置了密码
  final bool hasPassword;

  ///
  /// 未读消息列表
  ///
  final TypeUnreadNotificationsModel typeUnreadNotifications;

  ///
  /// 用户信息模型
  const UserAttributesModelModel(
      {this.id,
      this.username,
      this.mobile,
      this.avatarUrl = "",
      this.loginAt = "",
      this.joinedAt = "",
      this.expiredAt = "",
      this.identity = "",
      this.realname = "",
      this.createdAt = "",
      this.lastLoginIp = "",
      this.updatedAt = "",
      this.originalMobile = "",
      this.registerIp = "",
      this.walletBalance = "0.00",
      this.registerReason = "",
      this.banReason = "",
      this.payTime = "",
      this.signature = "",
      this.canDelete = false,
      this.canEditUsername = false,
      this.mobileConfirmed = false,
      this.canWalletPay = false,
      this.hasPassword = false,
      this.follow = 0,
      this.likedCount = 0,
      this.threadCount = 0,
      this.unreadNotifications = 0,
      this.canEdit = false,
      this.paid = false,
      this.fansCount = 0,
      this.status = 0,
      this.usernameBout = 0,
      this.typeUnreadNotifications,
      this.followCount = 0});

  ///
  /// 使用一个已经存在的User，浅拷贝复制部分属性，活得一个新的用户对象
  ///为了安全起见，不是所有的属性都能这样操作
  static UserAttributesModelModel copyWith({
    @required UserAttributesModelModel attributes,
    String username,
    int follow,
    int fansCount,
    String mobile,
    String avatarUrl,
  }) {
    assert(attributes != null);
    if (attributes == const UserAttributesModelModel())
      return const UserAttributesModelModel();

    return UserAttributesModelModel(
        id: attributes.id,
        username: username ?? attributes.username,
        follow: follow ?? attributes.follow,
        mobile: mobile ?? attributes.mobile,

        /// todo: 脱敏mobile
        canDelete: attributes.canDelete,
        hasPassword: attributes.hasPassword,
        registerReason: attributes.registerReason,
        avatarUrl: avatarUrl ?? attributes.avatarUrl,
        originalMobile: mobile ?? attributes.mobile,
        loginAt: attributes.loginAt,
        banReason: attributes.banReason,
        expiredAt: attributes.expiredAt,
        joinedAt: attributes.joinedAt,
        identity: attributes.identity,
        fansCount: fansCount ?? attributes.fansCount,
        registerIp: attributes.registerIp,
        followCount: attributes.followCount,
        lastLoginIp: attributes.lastLoginIp,
        walletBalance: attributes.walletBalance,
        canEdit: attributes.canEdit,
        paid: attributes.paid,
        payTime: attributes.payTime,
        canWalletPay: attributes.canWalletPay,
        createdAt: attributes.createdAt,
        signature: attributes.signature,
        threadCount: attributes.threadCount,
        likedCount: attributes.likedCount,
        status: attributes.status,
        typeUnreadNotifications: attributes.typeUnreadNotifications,
        unreadNotifications: attributes.unreadNotifications,
        mobileConfirmed: attributes.mobileConfirmed,
        canEditUsername: attributes.canEditUsername,
        realname: attributes.realname,
        usernameBout: attributes.usernameBout);
  }

  ///
  /// fromMap
  /// 转换模型
  ///
  static UserAttributesModelModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const UserAttributesModelModel();
    }

    dynamic data = maps;

    /// 数���来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return UserAttributesModelModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        username: data['username'] ?? '',
        mobile: data['mobile'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        hasPassword: data['hasPassword'] ?? false,
        canEditUsername: data['canEditUsername'] ?? false,
        threadCount: data['threadCount'] == null
            ? 0
            : data['threadCount'].runtimeType == String
                ? int.tryParse(data['threadCount'])
                : data['threadCount'],
        followCount: data['followCount'] == null
            ? 0
            : data['followCount'].runtimeType == String
                ? int.tryParse(data['followCount'])
                : data['followCount'],
        fansCount: data['fansCount'] == null
            ? 0
            : data['fansCount'].runtimeType == String
                ? int.tryParse(data['fansCount'])
                : data['fansCount'],
        follow: data['follow'] == null
            ? 0
            : data['follow'].runtimeType == String
                ? int.tryParse(data['follow'])
                : data['follow'],
        likedCount: data['likedCount'] == null
            ? 0
            : data['likedCount'].runtimeType == String
                ? int.tryParse(data['likedCount'])
                : data['likedCount'],
        status: data['status'] == null
            ? 0
            : data['status'].runtimeType == String
                ? int.tryParse(data['status'])
                : data['status'],
        usernameBout: data['usernameBout'] == null
            ? 0
            : data['usernameBout'].runtimeType == String
                ? int.tryParse(data['usernameBout'])
                : data['usernameBout'],
        loginAt: data['loginAt'] ?? '',
        joinedAt: data['joinedAt'] ?? '',
        expiredAt: data['expiredAt'] ?? '',
        createdAt: data['createdAt'] ?? '',
        updatedAt: data['updatedAt'] ?? '',
        canEdit: data['canEdit'] ?? false,
        canDelete: data['canDelete'] ?? false,
        canWalletPay: data['canWalletPay'] ?? false,
        registerReason: data['registerReason'] ?? '',
        banReason: data['banReason'] ?? '',
        originalMobile: data['originalMobile'] ?? '',
        mobileConfirmed: data['mobileConfirmed'] ?? false,
        registerIp: data['registerIp'] ?? '',
        lastLoginIp: data['lastLoginIp'] ?? '',
        identity: data['identity'] ?? '',
        signature: data['signature'] ?? '',
        realname: data['realname'] ?? '',
        walletBalance: data['walletBalance'] ?? '',
        paid: data['paid'] ?? false,
        payTime: data['payTime'] ?? '',
        unreadNotifications: data['unreadNotifications'] == null
            ? 0
            : data['unreadNotifications'].runtimeType == String
                ? int.tryParse(data['unreadNotifications'])
                : data['unreadNotifications'],
        typeUnreadNotifications: data['typeUnreadNotifications'] == null
            ? const TypeUnreadNotificationsModel()
            : TypeUnreadNotificationsModel.fromMap(
                maps: data['typeUnreadNotifications']));
  }
}
