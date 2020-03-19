import 'dart:convert';
import 'package:flutter/material.dart';

class UserModel {
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

  ///
  /// 用户信息模型
  const UserModel(
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
      this.canDelete = false,
      this.mobileConfirmed = false,
      this.canWalletPay = false,
      this.follow = 0,
      this.threadCount = 0,
      this.unreadNotifications = 0,
      this.canEdit = false,
      this.paid = false,
      this.fansCount = 0,
      this.status = 0,
      this.followCount = 0});

  ///
  /// fromMap
  /// 转换模型
  /// 
  static UserModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return UserModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return UserModel();
  }
}
