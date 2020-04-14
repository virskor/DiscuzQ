import 'package:flutter/material.dart';

import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/editor.dart';
import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';

///
/// DiscuzEditorReplyHelper
/// 该组件仅用于管理评论组件的回复编辑器调用
///
class DiscuzEditorReplyHelper {
  ///
  /// BuildContext
  ///
  final BuildContext context;

  ///
  /// 回复工具类
  DiscuzEditorReplyHelper({this.context});

  ///
  /// 打开编辑器回复指定评论
  ///
  Future<void> reply({@required PostModel post, @required ThreadModel thread}) =>
      DiscuzRoute.open(
          context: context,
          fullscreenDialog: true,
          shouldLogin: true,
          widget: Editor(
            type: DiscuzEditorInputTypes.reply,
            post: post,
            thread: thread,
          ));
}
