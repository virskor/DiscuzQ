import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/models/attachmentsModel.dart';
import 'package:core/models/categoryModel.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/providers/editorProvider.dart';

class EditorDataPostType {
  ///
  /// 普通帖子
  static const typeNormalContent = 0;

  ///
  /// 长文
  static const typeLongContent = 1;

  ///
  /// 发布视频帖子
  static const typeVideoContent = 2;

  const EditorDataPostType();
}

class DiscuzEditorData {
  ///
  /// 类型，默认不用传入
  final String type;

  ///
  /// 关联的数据
  final DiscuzEditorDataRelationships relationships;

  ///
  /// 用户编辑的数据
  final DiscuzEditorDataAttributes attributes;

  DiscuzEditorData(
      {this.type = 'threads',

      /// 默认发帖
      this.relationships,
      this.attributes});

  ///
  /// 更新
  static DiscuzEditorData fromDiscuzEditorData(
    DiscuzEditorData data, {
    BuildContext context,
    String captchaRandSTR,
    captchaTicket,
    content,
    title,
    ThreadModel thread,
    PostModel post,
    int type = EditorDataPostType.typeNormalContent,
  }) =>
      DiscuzEditorData(

          /// 发帖，还是评论？
          type: post == null ? 'threads' : 'posts',
          relationships: DiscuzEditorDataRelationships(
              thread: thread,
              category: context.read<EditorProvider>().categories,
              attachments: context.read<EditorProvider>().attachements),
          attributes: DiscuzEditorDataAttributes(
              captchaRandSTR: captchaRandSTR ?? '',
              captchaTicket: captchaTicket ?? '',
              type: type,
              title: title ?? '',
              replyId: post == null ? 0 : post.id,
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

  ///
  /// 回复时会关联帖子thread主题的信息
  /// 没有thread则会变成发帖
  final ThreadModel thread;

  const DiscuzEditorDataRelationships(
      {this.category, this.attachments = const [], this.thread});
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
  /// 标题
  final String title;

  ///
  /// 类型 文章类型(
  /// 0 DiscuzEditorData.typeNormalContent 普通
  /// 1 DiscuzEditorData.typeLongContent 长文
  /// 2 DiscuzEditorData.typeVideoContent 视频)
  final int type;

  ///
  /// 关联的回复ID
  /// 当回复模式的时候，要提供replyId 即目标Post的ID
  final int replyId;

  const DiscuzEditorDataAttributes(
      {this.captchaRandSTR = '',
      this.captchaTicket = '',
      this.content = '',
      this.title = '',
      this.replyId = 0,
      this.type = EditorDataPostType.typeNormalContent});
}
