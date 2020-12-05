import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:core/models/setSiteModel.dart';
import 'package:core/models/siteRegModel.dart';
import 'package:core/models/agreementsModel.dart';
import 'package:core/models/qCloudModel.dart';

///
/// 站点信息
/// todo: 现在，我们只转化了 setSite 和 siteReg模型，
/// 其他模型由于暂未用到，在未来的开发进程中需要进一步的转化模型
///
class ForumModel {
  final ForumAttributesModel attributes;

  const ForumModel({this.attributes = const ForumAttributesModel()});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ForumModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const ForumModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ForumModel(
        attributes: ForumAttributesModel.fromMap(maps: data['attributes']));
  }
}

class ForumAttributesModel {
  ///
  /// set_sites
  /// 站点配置信息
  final SetSiteModel setSite;

  ///
  /// set_reg
  /// 站点用户注册配置信息
  final SiteRegModel siteReg;

  ///
  /// 腾讯云相关配置
  /// qcloud
  final QCloudModel qcloud;

  /// 条款
  /// agreement
  final AgreementsModel agreements;

  const ForumAttributesModel(
      {this.setSite = const SetSiteModel(),
      this.siteReg = const SiteRegModel(),
      this.agreements = const AgreementsModel(),
      this.qcloud = const QCloudModel()});

  ///
  /// fromMap
  /// 转换模型
  ///
  static ForumAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const ForumAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return ForumAttributesModel(
      setSite: SetSiteModel.fromMap(maps: data['set_site'] ?? null),
      siteReg: SiteRegModel.fromMap(maps: data['set_reg'] ?? null),
      qcloud: QCloudModel.fromMap(maps: data['qcloud'] ?? null),
      agreements: AgreementsModel.fromMap(maps: data['agreement'] ?? null)
    );
  }
}
