import 'package:flutter/material.dart';

///
/// 可用的输入类型
/// 
class DiscuzEditorInputTypes {
  ///
  /// 用户输入后，要进行的操作是发布主题
  /// 
  static const DiscuzEditorInputType text = DiscuzEditorInputType(
      formatType: DiscuzEditorInputType.formatTypesString, name: '主题');
  

  ///
  /// 用户输入后要进行的操作是发布回复
  /// 
  static const DiscuzEditorInputType reply = DiscuzEditorInputType(
      formatType: DiscuzEditorInputType.formatTypesString, name: '回复');

  ///
  /// 用户输入后要进行的操作是发布长文，这个输入调用的是Markdown编辑器
  /// 
  static const DiscuzEditorInputType markdown = DiscuzEditorInputType(
      formatType: DiscuzEditorInputType.formatTypesMarkdown, name: '长文');

  ///
  /// 用户输入后，要发布的是视频
  /// 
  static const DiscuzEditorInputType video = DiscuzEditorInputType(
      formatType: DiscuzEditorInputType.formatTypesVideo, name: '视频');
  const DiscuzEditorInputTypes();
}

///
/// 输入类型
/// 
class DiscuzEditorInputType {
  ///
  /// 输入类型的名称
  final String name;

  /// 输入类型的转化格式
  ///
  final String formatType;

  ///
  /// 转化为一般的字符串格式
  static const formatTypesString = 'text';

  /// 转化为一般的markdown格式
  static const formatTypesMarkdown = 'markdown';

  /// 包含视频的
  static const formatTypesVideo = 'video';

  const DiscuzEditorInputType({@required this.name, @required this.formatType});
}
