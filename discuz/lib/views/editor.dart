import 'package:discuzq/widgets/appbar/appbarSaveButton.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/editor/discuzEditor.dart';
import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';
import 'package:discuzq/widgets/editor/discuzMarkdownEditor.dart';

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
  final DiscuzEditorInputType type;

  Editor({@required this.type});

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ///
  /// uniqueKey
  final UniqueKey uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) {
        return Scaffold(
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
        );
      });

  ///
  /// 生成保存按钮的
  Widget _buildSaveButton() {
    if (widget.type == DiscuzEditorInputTypes.reply) {
      return AppbarSaveButton(
        onTap: () => DiscuzToast.failed(context: context, message: '暂不开放'),
        label: '回复',
      );
    }

    return AppbarSaveButton(
      onTap: () => DiscuzToast.failed(context: context, message: '暂不开放'),
      label: '发布',
    );
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
      );
    }

    ///
    /// 主题和视频的，都使用一般的编辑器就可以了
    /// 默认允许表情，上传图片，上传附件
    return DiscuzEditor();
  }
}
