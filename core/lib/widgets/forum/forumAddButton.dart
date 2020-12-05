import 'dart:ui';

import 'package:core/widgets/common/discuzListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/editor/discuzEditorInputTypes.dart';
import 'package:core/models/categoryModel.dart';
import 'package:core/widgets/editor/discuzEditorHelper.dart';
import 'package:core/widgets/editor/discuzEditorRequestResult.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ForumAddButton extends StatefulWidget {
  ///
  /// 图标颜色永远渲染白色
  final bool awalysDark;

  final EdgeInsetsGeometry padding;

  const ForumAddButton({Key key, this.awalysDark = false, this.padding})
      : super(key: key);

  @override
  _ForumAddButtonState createState() => _ForumAddButtonState();
}

class _ForumAddButtonState extends State<ForumAddButton> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: widget.padding ?? const EdgeInsets.all(8.0),
      icon: DiscuzIcon(
        CupertinoIcons.plus,
        color: widget.awalysDark
            ? Colors.white
            : DiscuzApp.themeOf(context).textColor,
      ),
      onPressed: _showPop,
    );
  }

  ///
  /// show pop
  ///
  Future<bool> _showPop() => showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const Material(
          color: Colors.transparent, child: const _ForumCreateThreadDialog()));
}

/// 创建帖子的对话框
class _ForumCreateThreadDialog extends StatefulWidget {
  const _ForumCreateThreadDialog({Key key}) : super(key: key);

  @override
  _ForumCreateThreadDialogState createState() =>
      _ForumCreateThreadDialogState();
}

class _ForumCreateThreadDialogState extends State<_ForumCreateThreadDialog> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  static const List<_ForumCreateThreadDialogItem> _menus = [
    const _ForumCreateThreadDialogItem(
        caption: '发布主题',
        subTitle: '一些简单的想法',
        type: DiscuzEditorInputTypes.text,
        icon: CupertinoIcons.pencil_ellipsis_rectangle),
    const _ForumCreateThreadDialogItem(
        type: DiscuzEditorInputTypes.markdown,
        caption: '发布长文',
        subTitle: '发布我的文章',
        icon: CupertinoIcons.pencil_outline),
    // const _ForumCreateThreadDialogItem(
    //     type: DiscuzEditorInputTypes.video,
    //     caption: '发布视频',
    //     subTitle: '发布我的小视频',
    //     icon: CupertinoIcons.videocam_fill),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: _menus
              .map((e) => GestureDetector(
                    onTap: () => _showEditor(
                      context: context,
                      type: e.type,
                    ),
                    child: DiscuzListTile(
                      leading: Center(
                        widthFactor: 2,
                        child: DiscuzIcon(e.icon),
                      ),
                      title: DiscuzText(
                        e.caption,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: DiscuzText(
                        e.subTitle,
                        color: DiscuzApp.themeOf(context).greyTextColor,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  ///
  /// 打开编辑器
  ///
  Future<void> _showEditor(
      {BuildContext context,
      DiscuzEditorInputType type,
      CategoryModel category}) async {
    final DiscuzEditorRequestResult res =
        await DiscuzEditorHelper(context: context)
            .createThread(type: type, category: category);
    if (res != null) {
      ///
      /// todo: 刷新列表
      DiscuzToast.toast(context: context, message: '发布成功');
    }

    /// 对话框一定在后关闭，否则会造成widget tree unstable
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }
}

///
/// 发帖选项
class _ForumCreateThreadDialogItem {
  ///
  /// 选项卡标题
  final String caption;

  ///
  /// 副标题
  final String subTitle;

  ///
  /// 图标
  final IconData icon;

  final DiscuzEditorInputType type;

  const _ForumCreateThreadDialogItem(
      {this.caption, this.subTitle, this.icon, this.type});
}
