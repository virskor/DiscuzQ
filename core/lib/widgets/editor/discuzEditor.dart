import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_text_field/extended_text_field.dart';

import 'package:core/widgets/editor/toolbar/discuzEditorToolbar.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/models/emojiModel.dart';
import 'package:core/widgets/emoji/emojiSwiper.dart';
import 'package:core/models/categoryModel.dart';
import 'package:core/widgets/editor/uploaders/discuzEditorAttachementUploader.dart';
import 'package:core/widgets/editor/uploaders/discuzEditorImageUploader.dart';
import 'package:core/widgets/editor/formaters/discuzEditorData.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';
import 'package:core/widgets/editor/toolbar/toolbarEvt.dart';
import 'package:core/widgets/editor/specialSpanBuilders/discuzEditorSpecialSpanBuilder.dart';
import 'package:core/utils/debouncer.dart';

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
  /// 关联的Post type == DiscuzEditorInputTypes.reply 则需要传入post
  /// 如果不传入，那么也不会成功的换为回复模式
  ///
  /// 如果为编辑post时，type则不能是 DiscuzEditorInputTypes.reply
  final DiscuzEditorData data;

  ///
  /// 传入默认关联的分类
  /// 如果不传入，那么右下角的切换分类菜单将不会显示
  /// 发布，编辑时需要传入，回复的时候不需要传入的
  final CategoryModel defaultCategory;

  ///
  /// 编辑器数据发生变化
  ///
  final Function onChanged;

  ///
  /// 关联的评论
  final PostModel post;

  ///
  /// 关联的主题
  final ThreadModel thread;

  ///
  /// 是否开启markdown编辑模式
  final bool enableMarkdown;

  DiscuzEditor(
      {this.enableEmoji = true,
      this.enableUploadImage = true,
      this.enableMarkdown = false,
      this.onChanged,
      this.defaultCategory,
      this.data,
      this.post,
      this.thread,
      this.enableUploadAttachment = true});
  @override
  _DiscuzEditorState createState() => _DiscuzEditorState();
}

class _DiscuzEditorState extends State<DiscuzEditor> {
  ///
  /// text controller
  ///
  final TextEditingController _contentEditController = TextEditingController();

  ///
  /// title controller
  final TextEditingController _titleEditController = TextEditingController();

  ///
  /// editor focus node
  final FocusNode _editorFocusNode = FocusNode();

  /// debouncer
  final Debouncer _debouncer = Debouncer(milliseconds: 400);

  ///
  /// states
  ///
  ToolbarEvt _toolbarEvt;

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

  ///
  /// 是否显示收起键盘
  bool _showHideKeyboardButton = false;

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

    ///
    /// 处理编辑器焦点，从而显示收起键盘的按钮
    ///
    _editorFocusNode.addListener(() {
      ///
      /// 要避免重复的UI更新
      if (_editorFocusNode.hasFocus == _showHideKeyboardButton) {
        return;
      }

      /// 失去焦点的时候，就不显示收齐键盘的按钮
      setState(() {
        _showHideKeyboardButton = _editorFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _contentEditController.dispose();
    _editorFocusNode.dispose();
    _titleEditController.dispose();
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
            enableEmoji: widget.enableEmoji,
            enableUploadAttachment: widget.enableUploadAttachment,
            enableUploadImage: widget.enableUploadImage,
            enableMarkdown: widget.enableMarkdown,
            showHideKeyboardButton: _showHideKeyboardButton,
            defaultCategory: widget.defaultCategory,
            onRequestUpdate: () {
              _onChanged();
            },
            hideCategorySelector: widget.post != null,
            onTap: (ToolbarEvt toolbarEvt,
                {String formatValue, bool asNewLine}) {
              ///
              /// 如果 formatValue 不为Null 仅为编辑器插入formatValue，但不继续运行
              if (formatValue != null) {
                _addEditorVal(formatValue, asNewLine: asNewLine ?? false);
                return;
              }

              ///
              /// 处理图片选择器
              /// 附件选择器
              /// 表情选择器等显示
              setState(() {
                _toolbarEvt = toolbarEvt;
                _neverShowToolbarChild = false;
              });
            },
            child: _buildToolbarChild(),
          ),
        )
      ],
    );
  }

  ///
  /// 生成编辑器
  Widget _buildEditor() {
    return Column(
      children: [
        ///
        /// 输入标题
        ///
        widget.enableMarkdown
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DiscuzTextfiled(
                  placeHolder: '请输入标题',
                  removeBottomMargin: true,
                  contentPadding: const EdgeInsets.all(0),
                  controller: _titleEditController,
                  fontSize: DiscuzApp.themeOf(context).mediumTextSize,
                  onChanged: (String data) => _onChanged(data: data),
                ),
              )
            : const SizedBox(),

        /// 内容编辑
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 60),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: ExtendedTextField(
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
              controller: _contentEditController,
              onChanged: (String data) => _onChanged(data: data),
              maxLines: 20,
              autocorrect: false,
              autofocus: true,
              focusNode: _editorFocusNode,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '点击以输入内容',
                  contentPadding: EdgeInsets.all(12.0),
                  hintStyle: TextStyle(
                      color: DiscuzApp.themeOf(context).greyTextColor)),
              style: TextStyle(
                  fontSize: DiscuzApp.themeOf(context).normalTextSize,
                  color: DiscuzApp.themeOf(context).textColor),
              specialTextSpanBuilder:
                  DiscuzEditorSpecialTextSpanBuilder(context: context),
            ),
          ),
        )
      ],
    );
  }

  ///
  /// add edit text for textfiled
  /// 为编辑器增加用户正在编辑的数据
  /// data 要添加的数据
  /// state 编辑器状态
  /// asNewLine 是否换行
  void _addEditorVal(String data, {bool asNewLine = false}) {
    final String text =
        "${_contentEditController.text}${asNewLine ? '\r\n' : ''}$data";

    _contentEditController.value = TextEditingValue(text: text);
    _onChanged();
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
    if (_toolbarEvt == ToolbarEvt.emoji) {
      return EmojiSwiper(
        onInsert: (EmojiModel emoji) {
          ///
          /// 编辑器植入表情
          _addEditorVal(emoji.attributes.code);
        },
      );
    }

    ///
    /// 用户选择了图片上传
    /// 上传的图片数据直接从editorState中取得
    if (_toolbarEvt == ToolbarEvt.image) {
      return DiscuzEditorImageUploader(
        onUploaded: () {
          _onChanged();

          /// 用户上传了图片，触发编辑器数据更新
        },
      );
    }

    ///
    /// 用户选择了上传附件
    /// 上传的附件数据直接从editorState中取得
    if (_toolbarEvt == ToolbarEvt.attachment) {
      return DiscuzEditorAttachementUploader(
        onUploaded: () {
          _onChanged();

          /// 用户上传了附件，触发编辑器数据更新
        },
      );
    }

    return const SizedBox();
  }

  ///
  /// 数据转化，用于最终提交
  /// data 暂时可以忽略
  Future<void> _onChanged({String data}) async {
    if (widget.onChanged == null) {
      return;
    }

    _debouncer.run(() {
      ///
      /// 先执行一次转化为editorData的操作，确保编辑器回调的数据为最终的数据
      /// 更新编辑器Data的时候 切记不要调用setState
      _updateEditorData();

      ///
      /// 将编辑器的_discuzEditorData传到调用编辑器的组件，
      /// 然后让其调用formter转化为最终的用户用于提交的数据进行提交
      /// 延迟回调，性能优化
      widget.onChanged(_discuzEditorData);
    });
  }

  ///
  /// 自动计算当前提模式值
  /// 是这样的，长文，普通，视频
  int _editorDataPostType() {
    /// 长文模式
    if (_titleEditController.text != '') {
      return EditorDataPostType.typeLongContent;
    }

    ///todo: 视频模式
    return EditorDataPostType.typeNormalContent;
  }

  ///
  /// 更新编辑器数据
  /// 更新编辑器Data的时候 切记不要调用setState
  /// 有几个地方会触发编辑器数据更新
  /// 用户输入或编辑器数据发生变化的时候
  /// 用户选择表情的时候
  /// 用户上传图片成功的时候
  /// 用户上传附件的时候
  /// 用户选择分类的时候
  ///
  /// 注意：仅_onChanged调用这个方法，请不要再其他地方，调用这个方法，以便更新逻辑过于混乱
  void _updateEditorData() {
    ///
    /// 仅调试开发模式下输出
    debugPrint(_contentEditController.text);

    DiscuzEditorData d = _discuzEditorData;

    ///
    /// 更新编辑器用户编辑的内容
    d = DiscuzEditorData.fromDiscuzEditorData(
      d,
      context: context,
      content: _contentEditController.text,
      title: _titleEditController.text,
      thread: widget.thread,
      post: widget.post,
      type: _editorDataPostType(),
    );

    ///
    /// 更新状态，但不影响UI
    /// 不要setState
    _discuzEditorData = d;
  }
}
