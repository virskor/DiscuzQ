import 'package:flutter/material.dart';

import 'package:discuzq/widgets/editor/discuzEditorToolbar.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/models/emojiModel.dart';
import 'package:discuzq/widgets/emoji/emojiSwiper.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/editor/uploaders/discuzEditorAttachementUploader.dart';
import 'package:discuzq/widgets/editor/uploaders/discuzEditorImageUploader.dart';
import 'package:discuzq/states/editorState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/editor/formaters/discuzEditorData.dart';

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
  /// 传入默认关联的分类
  /// 如果不传入，那么右下角的切换分类菜单将不会显示
  /// 发布，编辑时需要传入，回复的时候不需要传入的
  final CategoryModel bindCategory;

  ///
  /// 编辑器数据发生变化
  ///
  final Function onChanged;

  DiscuzEditor(
      {this.enableEmoji = true,
      this.enableUploadImage = true,
      this.onChanged,
      this.bindCategory,
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

  ///
  /// 默认情况下，不要将_neverShowToolbarChild设置为true
  /// 这将导致表情，图片选择等组件变成不可用的
  /// 只有在用户打开了这些组件，又点击了编辑器输入，键盘弹出时才设置为true,这样来自动隐藏表情等选择器
  /// 这么做是为了保证足够的输入空间
  ///
  bool _neverShowToolbarChild = false;

  ///
  /// 编辑器数据
  ///
  DiscuzEditorData _discuzEditorData;

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
    return ScopedStateModelDescendant<EditorState>(
      rebuildOnChange: false,
      builder: (BuildContext context, child, state) {
        return Stack(
          children: <Widget>[
            _buildEditor(),
            Positioned(
              bottom: 0,
              child: DiscuzEditorToolbar(
                enableEmoji: widget.enableEmoji,
                enableUploadAttachment: widget.enableUploadAttachment,
                enableUploadImage: widget.enableUploadImage,
                child: _buildToolbarChild(),
                onTap: (String toolbarEvt) {
                  ///
                  /// 处理图片选择器
                  /// 附件选择器
                  /// 表情选择器等显示
                  setState(() {
                    _toolbarEvt = toolbarEvt;
                    _neverShowToolbarChild = false;
                  });
                },
              ),
            )
          ],
        );
      },
    );
  }

  ///
  /// 生成编辑器
  Widget _buildEditor() {
    return Container(
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: TextField(
        onTap: () {
          ///
          /// 点击时。要为用户自动隐藏toolbar child
          /// 无需多次rebuild UI, 如果已经隐藏，return
          if (_neverShowToolbarChild) {
            return;
          }
          setState(() {
            _neverShowToolbarChild = true;
          });
        },
        keyboardAppearance: DiscuzApp.themeOf(context).brightness,
        controller: _controller,
        onChanged: (String data) => _onChanged(data: data),
        maxLines: 20,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '点击以输入内容',
            contentPadding: EdgeInsets.all(12.0),
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
    if (_toolbarEvt == null || _neverShowToolbarChild) {
      return const SizedBox();
    }

    ///
    /// 用户选择了插入表情
    ///
    if (_toolbarEvt == 'emoji') {
      return EmojiSwiper(
        onInsert: (EmojiModel emoji) {
          ///
          /// 编辑器植入表情
          final String text = "${_controller.text} ${emoji.attributes.code}  ";
          _controller.value = TextEditingValue(text: text);
        },
      );
    }

    ///
    /// 用户选择了图片上传
    /// 上传的图片数据直接从editorState中取得
    if (_toolbarEvt == 'image') {
      return DiscuzEditorImageUploader();
    }

    ///
    /// 用户选择了上传附件
    /// 上传的附件数据直接从editorState中取得
    if (_toolbarEvt == 'attachment') {
      return DiscuzEditorAttachementUploader();
    }

    return const SizedBox();
  }

  ///
  /// 数据转化，用于最终提交
  Future<void> _onChanged({String data}) async {
    if (widget.onChanged == null) {
      return;
    }
    
    ///
    /// 先执行一次转化为editorData的操作，确保编辑器回调的数据为最终的数据
    /// 更新编辑器Data的时候 切记不要调用setState
    _updateEditorData();

    ///
    /// 将编辑器的_discuzEditorData传到调用编辑器的组件，
    /// 然后让其调用formter转化为最终的用户用于提交的数据进行提交
    widget.onChanged(_discuzEditorData);
  }

  ///
  /// 更新编辑器数据
  /// 更新编辑器Data的时候 切记不要调用setState
  /// 有几个地方会触发编辑器数据更新
  /// 用户输入或编辑器数据发生变化的时候
  /// 用户选择表情的时候
  /// 用户上传图片成功的时候
  /// 用户上传附件的时候
  void _updateEditorData(){
    ///
    /// 更新编辑器用户编辑的内容
    
    ///
    /// 更新用户所选分类
    
    /// 更新用户上传的附件信息
  }
}
