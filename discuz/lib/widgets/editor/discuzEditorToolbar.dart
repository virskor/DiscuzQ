import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';

class DiscuzEditorToolbar extends StatefulWidget {
  final Function onTap;

  ///
  /// 用于嵌入的child
  final Widget child;

  DiscuzEditorToolbar({this.onTap, this.child});

  @override
  _DiscuzEditorToolbarState createState() => _DiscuzEditorToolbarState();
}

class _DiscuzEditorToolbarState extends State<DiscuzEditorToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ///
                /// 选择表情的按钮
                ///
                GestureDetector(
                  onTap: () => _callbackInput(toolbarEvt: 'emoji'),
                  child: const _ToolbarIconButton(
                    icon: Icons.face,
                  ),
                ),

                ///
                /// 选择图片
                ///

                GestureDetector(
                  onTap: () => _callbackInput(toolbarEvt: 'image'),
                  child: const _ToolbarIconButton(
                    icon: Icons.image,
                  ),
                ),

                ///
                /// 附件
                ///
                GestureDetector(
                  onTap: () => _callbackInput(toolbarEvt: 'attachment'),
                  child: const _ToolbarIconButton(
                    icon: Icons.attach_file,
                  ),
                ),
              ],
            ),

            ///
            /// child
            widget.child ?? const SizedBox()
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
