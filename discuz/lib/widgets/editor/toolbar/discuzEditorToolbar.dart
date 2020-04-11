import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/states/editorState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/editor/toolbar/discuzEditorCategorySelector.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

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

  DiscuzEditorToolbar(
      {this.onTap,
      this.child,
      this.enableUploadAttachment,
      this.enableEmoji,
      this.defaultCategory,
      this.onRequestUpdate,
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
    return ScopedStateModelDescendant<EditorState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Container(
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
                    _toolbarMenu(state: state),
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
                            DiscuzEditorCategorySelector(
                              onChanged: (CategoryModel category) {
                                state.updateCategory(category);
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
                                    child: const _ToolbarIconButton(
                                        icon: SFSymbols.keyboard_chevron_compact_down),
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
      ),
    );
  }

  ///
  /// 工具按按钮菜单
  Widget _toolbarMenu({EditorState state}) => SingleChildScrollView(
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
                    onTap: () => _callbackInput(toolbarEvt: 'emoji'),
                    child: const _ToolbarIconButton(
                      icon: SFSymbols.smiley,
                    ),
                  )
                : const SizedBox(),

            ///
            /// 选择图片
            ///

            widget.enableUploadImage
                ? Badge(
                    badgeContent: DiscuzText(
                      state.galleries.length.toString(),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(3),
                    animationType: BadgeAnimationType.fade,
                    elevation: 0,
                    position: BadgePosition(top: 2, right: 0),
                    showBadge:
                        state.galleries == null || state.galleries.length == 0
                            ? false
                            : true,
                    child: GestureDetector(
                      onTap: () => _callbackInput(toolbarEvt: 'image'),
                      child: const _ToolbarIconButton(
                        icon: SFSymbols.camera,
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
            //         child: const _ToolbarIconButton(
            //           icon: Icons.attach_file,
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      );

  ///
  /// callback to editor
  void _callbackInput({@required String toolbarEvt}) {
    _closeKeyboard();

    ///
    if (widget.onTap == null) {
      return;
    }

    widget.onTap(toolbarEvt);
  }

  ///
  /// close keyboard
  void _closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}

///
/// 点击表情按钮
///
class _ToolbarIconButton extends StatelessWidget {
  final IconData icon;

  const _ToolbarIconButton({@required this.icon});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: DiscuzIcon(
          icon,
          color: DiscuzApp.themeOf(context).greyTextColor,
        ),
      );
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
