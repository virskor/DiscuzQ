import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/editor/toolbar/toolbarIconButton.dart';
import 'package:core/widgets/common/discuzDivider.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/editor/toolbar/discuzEditorCategorySelector.dart';
import 'package:core/models/categoryModel.dart';
import 'package:flutter/cupertino.dart';
// import 'package:core/widgets/editor/toolbar/discuzEditorToolbarMarkdownItems.dart';
import 'package:core/widgets/editor/toolbar/toolbarEvt.dart';
import 'package:core/providers/editorProvider.dart';

class DiscuzEditorToolbar extends StatefulWidget {
  final Function onTap;

  ///
  /// 允许使用emoji
  ///
  final bool enableEmoji;

  ///
  /// 用于嵌入的child
  final Widget child;

  ///
  /// 允许上传图片
  ///
  final bool enableUploadImage;

  ///
  /// 允许上传附件
  ///
  final bool enableUploadAttachment;

  ///
  /// 是否显示收齐键盘图标
  /// showHideKeyboardButton
  final bool showHideKeyboardButton;

  ///
  /// 分类模型
  /// defaultCategory
  final CategoryModel defaultCategory;

  ///
  /// onRequestUpdate
  /// 如果toolbar中的项目会影响编辑器数据的时候
  /// 如用户选择了分类，那么要通知编辑更新数据，即执行编辑器中的 _onChanged
  final Function onRequestUpdate;

  ///
  /// 隐藏分类选择器
  /// 回复时，无需显示
  ///
  final bool hideCategorySelector;

  ///
  /// 是否开启markdown编辑模式
  final bool enableMarkdown;

  DiscuzEditorToolbar(
      {this.onTap,
      this.child,
      this.enableUploadAttachment,
      this.enableEmoji,
      this.defaultCategory,
      this.onRequestUpdate,
      this.enableMarkdown = false,
      this.hideCategorySelector = false,
      this.showHideKeyboardButton = false,
      this.enableUploadImage});

  @override
  _DiscuzEditorToolbarState createState() => _DiscuzEditorToolbarState();
}

class _DiscuzEditorToolbarState extends State<DiscuzEditorToolbar> {
  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    ///
    /// 确保_showHideKeyboardButton在组件创建前初始化而直接影响UIbuild 不要在init的时候setState
    _showHideKeyboardButton = widget.showHideKeyboardButton;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(DiscuzEditorToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    ///
    /// 处理隐藏键盘图标
    if (oldWidget.showHideKeyboardButton != widget.showHideKeyboardButton) {
      setState(() {
        _showHideKeyboardButton = widget.showHideKeyboardButton;
      });
    }
  }

  ///
  /// states
  bool _showHideKeyboardButton = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorProvider>(
        builder: (BuildContext context, EditorProvider editor, Widget child) {
      final Widget _toolbarMenu = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ///
            /// 选择表情的按钮
            ///
            widget.enableEmoji
                ? GestureDetector(
                    onTap: () => _callbackInput(toolbarEvt: ToolbarEvt.emoji),
                    child: const ToolbarIconButton(
                      icon: CupertinoIcons.smiley,
                    ),
                  )
                : const SizedBox(),

            ///
            /// 选择图片
            ///

            widget.enableUploadImage
                ? Badge(
                    badgeContent: DiscuzText(
                      editor.galleries.length.toString(),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(3),
                    animationType: BadgeAnimationType.fade,
                    elevation: 0,
                    position: BadgePosition(top: 2, end: 0),
                    showBadge:
                        editor.galleries == null || editor.galleries.length == 0
                            ? false
                            : true,
                    child: GestureDetector(
                      onTap: () => _callbackInput(toolbarEvt: ToolbarEvt.image),
                      child: const ToolbarIconButton(
                        icon: CupertinoIcons.camera,
                      ),
                    ),
                  )
                : const SizedBox(),

            ///
            /// 附件
            ///
            // widget.enableUploadAttachment
            //     ? GestureDetector(
            //         onTap: () => _callbackInput(toolbarEvt: 'attachment'),
            //         child: const ToolbarIconButton(
            //           icon: Icons.attach_file,
            //         ),
            //       )
            //     : const SizedBox(),

            ///
            /// 拓展 markdown工具栏
            ///
            /// todo: 优化markdown编辑类
            /// ...DiscuzEditorToolbarMarkdownItems.markdownOpts(
            ///    callbackInput: _callbackInput, show: widget.enableMarkdown),

            ///
            /// 防止无法滑动 多增加区域
            ///
            const SizedBox(width: 200),
          ],
        ),
      );

      return Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const DiscuzDivider(
                padding: 0,
              ),

              ///
              /// toolbar menu Items
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    _toolbarMenu,
                    Positioned(
                      right: 0,

                      ///
                      /// 右侧工具条
                      /// 有收起键盘，选择分类的按钮
                      child: _ToolbarExt(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ///
                            /// 选择分类
                            /// 用户选择了新的分类，那么就更新editor state
                            widget.hideCategorySelector
                                ? const SizedBox()
                                : DiscuzEditorCategorySelector(
                                    onChanged: (CategoryModel category) {
                                      context
                                          .read<EditorProvider>()
                                          .updateCategory(category);
                                      if (widget.onRequestUpdate != null) {
                                        widget.onRequestUpdate();
                                      }
                                    },
                                    defaultCategory: widget.defaultCategory,
                                  ),

                            /// 收键盘
                            _showHideKeyboardButton
                                ? GestureDetector(
                                    onTap: _closeKeyboard,
                                    child: const ToolbarIconButton(
                                        icon: CupertinoIcons
                                            .keyboard_chevron_compact_down),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///
              /// child
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: DiscuzApp.themeOf(context).backgroundColor),
                child: widget.child ?? const SizedBox(),
              )
            ],
          ),
        ),
      );
    });
  }

  ///
  /// callback to editor
  /// toolbar 请求在编辑器内插入信息（字符串） formatValue asNewLine 换行
  void _callbackInput(
      {@required ToolbarEvt toolbarEvt, String formatValue, bool asNewLine}) {
    if (formatValue == null) {
      _closeKeyboard();
    }

    ///
    if (widget.onTap == null) {
      return;
    }

    widget.onTap(toolbarEvt,
        formatValue: formatValue, asNewLine: asNewLine ?? false);
  }

  ///
  /// close keyboard
  void _closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}

///
/// 工具栏右侧按钮
class _ToolbarExt extends StatelessWidget {
  final Widget child;

  const _ToolbarExt({this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: DiscuzApp.themeOf(context).backgroundColor,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration:
            const BoxDecoration(border: const Border(left: Global.border)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: child,
        ),
      ),
    );
  }
}
