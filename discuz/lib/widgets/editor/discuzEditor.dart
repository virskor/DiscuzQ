import 'package:discuzq/models/emojiModel.dart';
import 'package:discuzq/widgets/emoji/emojiSwiper.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/editor/discuzEditorToolbar.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class DiscuzEditor extends StatefulWidget {
  ///
  /// 允许使用emoji
  ///
  final bool enableEmoji;

  ///
  /// 允许上传图片
  ///
  final bool enableUploadImage;

  ///
  /// 允许上传附件
  ///
  final bool enableUploadAttachment;

  ///
  /// 提交
  ///
  final Function onSubmit;

  DiscuzEditor(
      {this.enableEmoji = true,
      this.enableUploadImage = true,
      this.onSubmit,
      this.enableUploadAttachment = true});
  @override
  _DiscuzEditorState createState() => _DiscuzEditorState();
}

class _DiscuzEditorState extends State<DiscuzEditor> {
  ///
  /// text controller
  ///
  final TextEditingController _controller = TextEditingController();

  ///
  /// states
  ///
  String _toolbarEvt;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildEditor(),
        Positioned(
          bottom: 0,
          child: DiscuzEditorToolbar(
            child: _buildToolbarChild(),
            onTap: (String toolbarEvt) {
              ///
              /// 处理图片选择器
              /// 附件选择器
              /// 表情选择器等显示
              setState(() {
                _toolbarEvt = toolbarEvt;
              });
            },
          ),
        )
      ],
    );
  }

  ///
  /// 生成编辑器
  Widget _buildEditor() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: ExtendedTextField(
        keyboardAppearance: DiscuzApp.themeOf(context).brightness,
        controller: _controller,
        onSubmitted: (String data) => _formatSubmitData(data: data),
        maxLines: 20,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '点击以输入内容',
            hintStyle:
                TextStyle(color: DiscuzApp.themeOf(context).greyTextColor)),
        style: TextStyle(
            fontSize: DiscuzApp.themeOf(context).normalTextSize,
            color: DiscuzApp.themeOf(context).textColor),
      ),
    );
  }

  ///
  /// 当用户点击了toolbar的时候，生成不同的组件
  /// 如表情选择，图片选择等
  Widget _buildToolbarChild() {
    if (_toolbarEvt == null) {
      return SizedBox();
    }

    ///
    /// 用户选择了插入表情
    ///
    if (_toolbarEvt == 'emoji') {
      return EmojiSwiper(
        onInsert: (EmojiModel emoji) {},
      );
    }

    return Container();
  }

  ///
  /// 数据转化，用于最终提交
  Future<void> _formatSubmitData({String data}) async {
    if (widget.onSubmit == null) {
      return;
    }

    ///
    /// 转化数据，为纯文本数据，用于提交服务器
  }
}
