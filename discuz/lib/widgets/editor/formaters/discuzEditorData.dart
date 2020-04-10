import 'package:flutter/material.dart';

import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/categoryModel.dart';

class DiscuzEditorData {
  ///
  /// 类型，默认不用传入
  final String type;

  ///
  /// 关联的分类
  final CategoryModel category;

  ///
  /// 关联的数据
  final DiscuzEditorDataRelationships relationships;

  ///
  /// 用户编辑的数据
  final DiscuzEditorDataAttributes attributes;

  DiscuzEditorData(
      {this.type = 'threads',
      this.category,
      this.relationships,
      this.attributes});

  ///
  /// 更新
  static DiscuzEditorData fromDiscuzEditorData(DiscuzEditorData data,
          {String captchaRandSTR,
          captchaTicket,
          content,
          @required CategoryModel cat,
          List<AttachmentsModel> attachments = const []}) =>
      DiscuzEditorData(
          category: data.category,
          type: data.type,
          relationships: DiscuzEditorDataRelationships(
              category: cat, attachments: attachments ?? const []),
          attributes: DiscuzEditorDataAttributes(
              captchaRandSTR: captchaRandSTR ?? '',
              captchaTicket: captchaTicket ?? '',
              content: content ?? ''));
}

///
/// 提交数据时，编辑器关联的数据
/// 包含附件
/// 视频
/// 图片
class DiscuzEditorDataRelationships {
  ///
  /// 关联的分类
  /// category: {data: {type: "categories", id: "3"}}
  /// data: {type: "categories", id: "3"}
  final CategoryModel category;

  ///
  /// 关联的附件
  /// data: []
  final List<AttachmentsModel> attachments;

  const DiscuzEditorDataRelationships(
      {@required this.category, this.attachments = const []});
}

///
/// 用于提交的编辑器数据
class DiscuzEditorDataAttributes {
  ///
  /// 腾讯云验证码随机字符串
  final String captchaRandSTR;

  ///
  /// 验证码票据
  final String captchaTicket;

  ///
  /// 内容
  final String content;

  ///
  /// 类型
  final int type;

  const DiscuzEditorDataAttributes(
      {this.captchaRandSTR = '',
      this.captchaTicket = '',
      this.content = '',
      this.type = 0});
}
