import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/editor/discuzEditor.dart';
import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';
import 'package:discuzq/widgets/editor/discuzMarkdownEditor.dart';
import 'package:discuzq/states/editorState.dart';
import 'package:discuzq/widgets/appbar/appbarSaveButton.dart';
import 'package:discuzq/widgets/editor/formaters/discuzEditorData.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/editor/formaters/discuzEditorDataFormater.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/widgets/captcha/tencentCloudCaptcha.dart';
import 'package:discuzq/models/captchaModel.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/models/threadModel.dart';

///
/// 发帖编辑器
/// 发帖编辑器需要调用 discuzEditor 组件进行渲染用于渲染不同编辑模式下的编辑器
/// 模式分为：发（主题，长文），编辑(主题，回复)，视频
/// 注意：
/// 主题 不会支持markdown编辑 长文支持markdown编辑， 编辑时候也一样: todo: 如何确定编辑的是长文还是主题
/// 发送主题，或者长文，都要支持表情 图片 附件
/// 视频不会支持markdown，视频不会支持表情，附件，图片
/// 回复不会支持markdown,回复仅支持表情和图片，不支持附件
///
/// -------
/// 调用编辑模式，要使用DiscuzEditorDataModel.fromMap 对接口数据进行转化
/// 发布时，使用DiscuzEditorDataModel.toJson 获取用于发布的数据
/// 数据转化的内容包括
/// 表情，图片，附件，视频，分类，收费价格，编辑器content内容
///
/// 也就是调用编辑模式使用 const Editor(data: DiscuzEditorDataModel.fromMap(json));
/// 这样编辑器会自动调用数据编辑模式来，而接口则从新建，变为更新
///
///
class Editor extends StatefulWidget {
  ///
  /// 调用编辑器的模式
  final DiscuzEditorInputType type;

  ///
  /// 关联的Post type == DiscuzEditorInputTypes.reply 则需要传入post
  /// 如果不传入，那么也不会成功的换为回复模式
  ///
  /// 如果为编辑post时，type则不能是 DiscuzEditorInputTypes.reply
  final PostModel post;

  ///
  /// 传入默认关联的分类
  /// 如果不传入，那么右下角的切换分类菜单将不会显示
  /// 发布，编辑时需要传入，回复的时候不需要传入的
  final CategoryModel defaultCategory;

  ///
  /// 关联帖子
  /// 回复的时候，需要关联帖子数据，是不能少的
  final ThreadModel thread;

  Editor({@required this.type, this.post, this.defaultCategory, this.thread});

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ///
  /// uniqueKey
  final UniqueKey uniqueKey = UniqueKey();

  ///
  /// 编辑器数据
  /// 默认为nul
  DiscuzEditorData _discuzEditorData;

  @override
  Widget build(BuildContext context) => ScopedStateModel<EditorState>(
        model: EditorState(),
        child: Scaffold(
          key: uniqueKey,
          appBar: DiscuzAppBar(
            title: '发布${widget.type.name}',
            actions: <Widget>[
              _buildSaveButton(),
            ],
          ),
          backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(child: _buildEditor()),
            ],
          ),
        ),
      );

  ///
  /// 编辑器是否调用为回复模式
  bool _isReply() =>
      widget.type == DiscuzEditorInputTypes.reply && widget.post != null;

  ///
  /// 生成保存按钮的
  Widget _buildSaveButton() {
    ///
    /// 回复帖子
    if (_isReply()) {
      return AppbarSaveButton(
        onTap: _post,
        label: '回复',
      );
    }

    ///
    /// 编辑帖子
    if (widget.post != null) {
      return AppbarSaveButton(
        onTap: _post,
        label: '更新',
      );
    }

    ///
    /// 发布帖子
    return AppbarSaveButton(
      onTap: _post,
      label: '发布',
    );
  }

  ///
  /// 发布内容，
  /// 将自动处理数据转化，并根据模式，调用reply，或者创建主题的接口
  Future<void> _post() async {
    ///
    /// relationships 不可能为null
    ///
    if (_discuzEditorData.relationships == null) {
      ///
      /// data == null 这种情况，无非是缺少必要的参数category，提醒用户进行选择
      DiscuzToast.failed(context: context, message: '编辑器异常');
      return;
    }

    ///
    /// 回复的时候，不需要选择分类哈
    ///
    if (_discuzEditorData.relationships.category == null &&
        widget.type != DiscuzEditorInputTypes.reply) {
      ///
      /// data == null 这种情况，无非是缺少必要的参数category，提醒用户进行选择
      DiscuzToast.failed(context: context, message: '请选分类');
      return;
    }

    ///
    /// 小样，没有输入内容就想发布
    if (StringHelper.isEmpty(string: _discuzEditorData.attributes.content)) {
      DiscuzToast.failed(context: context, message: '请输入内容');
      return;
    }

    ///
    /// 启用腾讯云验证码
    /// 初始化时 null
    CaptchaModel captchaCallbackData;
    try {
      final AppState state =
          ScopedStateModel.of<AppState>(context, rebuildOnChange: false);

      ///
      /// 仅支持 开启腾讯云验证码的用户调用
      ///
      if (state.forum.attributes.qcloud.qCloudCaptcha) {
        captchaCallbackData = await TencentCloudCaptcha.show(
            context: context,

            ///
            /// 传入appID 进行替换，否则无法正常完成验证
            appID: state.forum.attributes.qcloud.qCloudCaptchaAppID);
        if (captchaCallbackData == null) {
          DiscuzToast.failed(context: context, message: '验证失败');
          return;
        }
      }
    } catch (e) {
      print(e);
    }

    ///
    /// 将编辑器模型数据，转化为JSON进行提交
    ///
    final dynamic data =
        await DiscuzEditorDataFormater.toJSON(_discuzEditorData,
            isBuildForCreatingPost: widget.post != null,

            /// 如果是回复，则该选项为true，这样会过滤掉发帖时非必要对的参数
            captcha: captchaCallbackData);

    ///
    /// 开始提交数据
    print(data);
    DiscuzToast.show(
        context: context, message: "出于安全考虑暂不开放发帖，以下是调试数据\r\n $data");
  }

  Widget _buildEditor() {
    if (widget.type.formatType == DiscuzEditorInputType.formatTypesMarkdown) {
      ///
      return DiscuzMarkdownEditor();
    }

    ///
    /// 回复模式不允许上传附件
    ///
    if (widget.type == DiscuzEditorInputTypes.reply) {
      return DiscuzEditor(
        enableUploadAttachment: false,
        defaultCategory: widget.defaultCategory,
        post: widget.post,
        thread: widget.thread,
        onChanged: (DiscuzEditorData data) {
          ///
          /// 切勿setState,否则UI将loop
          _discuzEditorData = data;
        },
      );
    }

    ///
    /// 主题和视频的，都使用一般的编辑器就可以了
    /// 默认允许表情，上传图片，上传附件
    return DiscuzEditor(
      defaultCategory: widget.defaultCategory,
      onChanged: (DiscuzEditorData data) {
        ///
        /// 切勿setState,否则UI将loop
        _discuzEditorData = data;
      },
    );
  }
}
