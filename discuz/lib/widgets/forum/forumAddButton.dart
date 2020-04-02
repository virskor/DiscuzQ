import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/views/editor.dart';
import 'package:discuzq/widgets/common/blurBackground.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class ForumAddButton extends StatefulWidget {
  ///
  /// 图标颜色永远渲染白色
  final bool awalysDark;

  const ForumAddButton({Key key, this.awalysDark = false}) : super(key: key);
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
      icon: DiscuzIcon(
        SFSymbols.plus,
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
  Future<bool> _showPop() => showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return const BlurDialogBackground(
          child: const _ForumCreateThreadDialog(),
        );
      });
}

class _ForumCreateThreadDialog extends StatelessWidget {
  const _ForumCreateThreadDialog();

  static const List<_ForumCreateThreadDialogItem> _menus = [
    const _ForumCreateThreadDialogItem(
        caption: '发布主题',
        subTitle: '一些简单的想法',
        type: DiscuzEditorInputTypes.text,
        icon: SFSymbols.pencil_ellipsis_rectangle),
    const _ForumCreateThreadDialogItem(
        type: DiscuzEditorInputTypes.markdown,
        caption: '发布长文',
        subTitle: '发布我的文章',
        icon: SFSymbols.pencil_outline),
    const _ForumCreateThreadDialogItem(
        type: DiscuzEditorInputTypes.video,
        caption: '发布视频',
        subTitle: '发布我的小视频',
        icon: SFSymbols.videocam_fill),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: _menus
              .map((e) => GestureDetector(
                    onTap: () => _showEditor(context: context, type: e.type),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: DiscuzApp.themeOf(context).backgroundColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(width: 20),
                          DiscuzIcon(e.icon),

                          ///
                          /// 制造间距
                          const SizedBox(width: 20),

                          /// 制造间距
                          ///
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DiscuzText(
                                e.caption,
                                fontWeight: FontWeight.bold,
                              ),
                              DiscuzText(
                                e.subTitle,
                                color: DiscuzApp.themeOf(context).greyTextColor,
                              ),
                            ],
                          )
                        ],
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
  Future<bool> _showEditor({BuildContext context, DiscuzEditorInputType type}) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }

    return DiscuzRoute.open(
        context: context, fullscreenDialog: true, widget: Editor(type: type));
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
