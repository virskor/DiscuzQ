import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/router/route.dart';
import 'package:core/views/editor.dart';
import 'package:core/widgets/editor/discuzEditorInputTypes.dart';
import 'package:core/models/categoryModel.dart';
import 'package:core/widgets/editor/discuzEditorRequestResult.dart';
import 'package:core/utils/authHelper.dart';

///
/// DiscuzEditorHelper
/// 该组件仅用于管理评论组件的回复编辑器调用
/// 任何组件不应该直接调用编辑器去发帖，或者创建回复，而是统一用这里的方法去请求
///
class DiscuzEditorHelper {
  ///
  /// BuildContext
  ///
  final BuildContext context;

  // ///
  // /// 帖子数据缓存器
  // /// 将用于展示帖子数据的缓存工具对象传入
  // /// 发帖成功后，数据将被push到缓存类中这样一来，UI什么都不用做，只要重新Build一下UI就可以展示用户发帖的结果
  // final ThreadsCacher threadCacher;

  ///
  /// 回复工具类
  DiscuzEditorHelper({this.context});

  ///
  /// 打开编辑器回复指定评论
  ///
  Future<DiscuzEditorRequestResult> reply(
      {@required PostModel post, @required ThreadModel thread}) async {
    DiscuzEditorRequestResult result;

    /// 弹出前，要检测用户是否已经登录
    try {
      final logined =
          await AuthHelper.requsetShouldLogin(context: context);
      if (!logined) {
        return Future.value(null);
      }
    } catch (e) {
      throw e;
    }

    await DiscuzRoute.navigate(
        context: context,
        isModal: true,
        widget: Editor(
          type: DiscuzEditorInputTypes.reply,
          post: post,
          thread: thread,
          onPostSuccess: (DiscuzEditorRequestResult res) {
            ///
            /// 用户成功回复，取得回复时接口反馈的数据
            result = res;
          },
        ));
    return Future.value(result);
  }

  ///
  /// 发帖
  ///
  ///
  /// 打开编辑器回复指定评论
  ///
  Future<DiscuzEditorRequestResult> createThread(
      {CategoryModel category, DiscuzEditorInputType type}) async {
    DiscuzEditorRequestResult result;
    await DiscuzRoute.navigate(
        context: context,
        fullscreenDialog: true,
        shouldLogin: true,
        isModal: false,
        widget: Editor(
          type: type,
          defaultCategory: category,
          onPostSuccess: (DiscuzEditorRequestResult res) {
            ///
            /// 用户成功回复，取得回复时接口反馈的数据
            result = res;
          },
        ));
    return Future.value(result);
  }
}
