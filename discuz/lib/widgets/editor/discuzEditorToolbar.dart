import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzIcon.dart';

class DiscuzEditorToolbar extends StatefulWidget {
  final Function onTap;

  DiscuzEditorToolbar({this.onTap});

  @override
  _DiscuzEditorToolbarState createState() => _DiscuzEditorToolbarState();
}

class _DiscuzEditorToolbarState extends State<DiscuzEditorToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(color: Colors.grey[600]),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ///
            /// 选择表情的按钮
            ///
            _EmojiButton(),

            ///
            /// 选择图片
            ///
            _ImageButton(),

            ///
            /// 附件
            ///
            _AttachmentButton(),
          ],
        ),
      ),
    );
  }

  /// 
  /// callback to editor
  void _callbackInput({String toolbarEvt}){
    _closeKeyboard();
    ///
    if(widget.onTap == null){
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
class _EmojiButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: DiscuzIcon(
        Icons.face,
        color: Colors.white,
      ),
      onPressed: () => null,
    );
  }
}


///
/// 点击附件按钮
/// 
class _AttachmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: DiscuzIcon(
        Icons.attach_file,
        color: Colors.white,
      ),
      onPressed: () => null,
    );
  }
}

///
/// 点击图片上传按钮
/// 
class _ImageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: DiscuzIcon(
        Icons.image,
        color: Colors.white,
      ),
      onPressed: () => null,
    );
  }
}
