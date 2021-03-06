import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/editor/discuzEditorHelper.dart';
import 'package:discuzq/widgets/editor/discuzEditorRequestResult.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';

class ForumAddButton extends StatefulWidget {
  final EdgeInsetsGeometry padding;

  const ForumAddButton({Key key, this.padding}) : super(key: key);

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
      padding: widget.padding ?? const EdgeInsets.all(4.0),
      icon: DiscuzIcon(
        CupertinoIcons.plus,
        size: 18,
        color: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
      ),
      onPressed: _showPop,
    );
  }

  ///
  /// show pop
  ///
  Future<bool> _showPop() => showCupertinoModalPopup(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10),
      context: context,
      builder: (BuildContext context) => const Material(
          color: Colors.transparent, child: const ForumCreateThreadDialog()));
}

/// 创建帖子的对话框
class ForumCreateThreadDialog extends StatefulWidget {
  const ForumCreateThreadDialog({Key key}) : super(key: key);

  @override
  ForumCreateThreadDialogState createState() => ForumCreateThreadDialogState();
}

class ForumCreateThreadDialogState extends State<ForumCreateThreadDialog> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  static const List<ForumCreateThreadDialogItem> _menus = [
    const ForumCreateThreadDialogItem(
        caption: '发布动态',
        subTitle: '一些简单的想法',
        type: DiscuzEditorInputTypes.text,
        icon: CupertinoIcons.pencil_ellipsis_rectangle),
    const ForumCreateThreadDialogItem(
        type: DiscuzEditorInputTypes.markdown,
        caption: '发布故事',
        subTitle: '发布我的故事',
        icon: CupertinoIcons.pencil_outline),
    // const ForumCreateThreadDialogItem(
    //     type: DiscuzEditorInputTypes.video,
    //     caption: '发布视频',
    //     subTitle: '发布我的小视频',
    //     icon: CupertinoIcons.videocam_fill),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      //margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
class ForumCreateThreadDialogItem {
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

  const ForumCreateThreadDialogItem(
      {this.caption, this.subTitle, this.icon, this.type});
}
