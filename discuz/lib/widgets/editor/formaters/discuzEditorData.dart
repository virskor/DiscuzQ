import 'package:flutter/material.dart';

import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/categoryModel.dart';

class DiscuzEditorData {
  final CategoryModel category;

  ///
  /// 关联的数据
  final DiscuzEditorDataRelationships relationships;

  ///
  /// 用户编辑的数据
  final DiscuzEditorDataAttributes attributes;

  DiscuzEditorData({this.category, this.relationships, this.attributes});

  ///
  /// 统一管理 relationships 更新
  /// 注意更新 attachments 和 category 时
  /// attachments 为null 更新为 const []
  /// category 为 null 则不更新(这种情况肯定是存在BUG) 提交数据时 category 是必选项
  set relationships(DiscuzEditorDataRelationships re) {
  }

  ///
  /// 统一管理 attributes 更新
  /// attributes 中，仅content受到用户的操作影响，其他数据不得由用户更新
  set attributes(DiscuzEditorDataAttributes attr) {}
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
