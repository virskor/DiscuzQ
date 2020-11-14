import 'dart:convert';
import 'package:flutter/material.dart';

class SetSiteModel {
  
  const SetSiteModel(
      {this.siteName = '',
      this.siteIntroduction = '',
      this.siteLogo = '',
      this.siteCloseMsg = '',
      this.sitePrice = 0.01,
      this.siteAuthorScale = 10,
      this.siteMasterScale = 0,
      this.siteAuthor,
      this.siteExpire = '',
      this.siteICP = '',
      this.siteStat = '',
      this.siteInstall = '',
      this.siteMode = 'public'});

  ///
  /// site_name
  /// 站点名称
  final String siteName;

  ///
  /// site_introduction
  /// 站点介绍
  final String siteIntroduction;

  ///
  /// site_mode
  /// 站点模式
  /// public公开模式pay付费模式
  final String siteMode;

  ///
  /// site_logo
  /// 站点LOGO Url
  final String siteLogo;

  ///
  /// site_close_msg
  /// 关闭原因
  final String siteCloseMsg;

  ///
  /// site_price
  /// 加入价格
  final double sitePrice;

  ///
  /// site_expire
  /// 到期时间
  /// site_mode='pay'时
  final String siteExpire;

  ///
  /// site_author_scale
  /// 作者比例
  /// 主题打赏分成比例,和站长比例加起来必须为10,不填时默认为作者10、平台0
  final double siteAuthorScale;

  ///
  /// site_master_scale
  /// 站长比例
  /// 主题打赏分成比例,和作者比例加起来必须为10,不填时默认为作者10、平台0
  final double siteMasterScale;

  ///
  /// site_icp
  /// 工信部备案号
  final String siteICP;

  /// site_stat
  /// 第三方统计代码
  /// 其实这个对于APP来说没有什么用对的
  final String siteStat;

  ///
  /// site_author
  /// 站点管理员
  ///
  /// {
  ///     "id":1,
  ///     "username":"admin"
  /// }
  final dynamic siteAuthor;

  ///
  /// site_install
  /// 站点安装时间
  final String siteInstall;

  ///
  /// fromMap
  /// 转换模型
  ///
  static SetSiteModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const SetSiteModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return SetSiteModel(
        siteName: data['site_name'] ?? '',
        siteIntroduction: data['site_introduction'] ?? '',
        siteLogo: data['site_logo'] ?? '',
        siteCloseMsg: data['site_close_msg'] ?? '',
        sitePrice: double.tryParse(data['site_price'] ?? '0.00'),
        siteAuthor: data['site_author'] ?? null,
        siteExpire: data['site_expire'] ?? null,
        siteICP: data['site_icp'] ?? '',
        siteStat: data['site_stat'] ?? '',
        siteInstall: data['site_install'] ?? '',
        siteMode: data['site_mode'] ?? '',
        siteMasterScale: double.tryParse(data['site_master_scale'] ?? '0.00'),
        siteAuthorScale: double.tryParse(data['site_author_scale'] ?? '0.00'));
  }
}
