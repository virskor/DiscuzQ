import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/ui/ui.dart';

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

  DiscuzEditorToolbar(
      {this.onTap,
      this.child,
      this.enableUploadAttachment,
      this.enableEmoji,
      this.enableUploadImage});

  @override
  _DiscuzEditorToolbarState createState() => _DiscuzEditorToolbarState();
}

class _DiscuzEditorToolbarState extends State<DiscuzEditorToolbar> {
  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(
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
                            icon: Icons.face,
                          ),
                        )
                      : const SizedBox(),

                  ///
                  /// 选择图片
                  ///

                  widget.enableUploadImage
                      ? GestureDetector(
                          onTap: () => _callbackInput(toolbarEvt: 'image'),
                          child: const _ToolbarIconButton(
                            icon: Icons.image,
                          ),
                        )
                      : const SizedBox(),

                  ///
                  /// 附件
                  ///
                  widget.enableUploadAttachment
                      ? GestureDetector(
                          onTap: () => _callbackInput(toolbarEvt: 'attachment'),
                          child: const _ToolbarIconButton(
                            icon: Icons.attach_file,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            const DiscuzDivider(
              padding: 0,
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
  }

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
