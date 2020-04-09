import 'package:flutter/material.dart';

import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/states/editorState.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/editor/formaters/discuzEditorData.dart';

///
/// 将编辑器的数据，转化为用于提交的Json数据
class DiscuzEditorDataFormater {
  ///
  /// 当编辑器要转为编辑模式，那么要传入关联的post，否则提交是将没有postid
  ///
  final PostModel post;

  ///
  /// 关联的EditorState
  final EditorState state;

  ///
  /// 关联的分类
  ///
  final CategoryModel category;

  const DiscuzEditorDataFormater(
      {@required this.state, @required this.category, this.post});

  ///
  /// 转化数据
  /// 将 DiscuzEditorData转化为json用于提交
  /// 数据处理时，会对应提交的格式转化
  Future<dynamic> toJSON({DiscuzEditorData data}) async {

  }

  ///
  /// 将数据转化为 DiscuzEditorData
  Future<dynamic> fromJSON({dynamic data}) async {}
}
