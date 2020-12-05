import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:core/widgets/editor/toolbar/toolbarEvt.dart';
import 'package:core/widgets/editor/toolbar/toolbarIconButton.dart';

class DiscuzEditorToolbarMarkdownItems {
  static List<Widget> markdownOpts(
      {@required bool show, Function callbackInput}) {
    final List<Widget> items = [
      ///
      /// 插入粗体字
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatBold,
            formatValue: '** **',
            asNewLine: false),
        child: const ToolbarIconButton(icon: CupertinoIcons.bold),
      ),

      ///
      /// 插入斜体字
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatItalic,
            formatValue: '_ _',
            asNewLine: false),
        child: const ToolbarIconButton(icon: CupertinoIcons.italic),
      ),

      ///
      /// 插入标题
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatHead,
            formatValue: '###  ',
            asNewLine: true),
        child: const ToolbarIconButton(icon: Icons.text_fields),
      ),

      /// 插入引用
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatQuote,
            formatValue: '>  ',
            asNewLine: true),
        child: const ToolbarIconButton(icon: CupertinoIcons.quote_bubble),
      ),

      /// 插入超链接
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatUrl,
            formatValue: '[ ]( )',
            asNewLine: false),
        child: const ToolbarIconButton(icon: CupertinoIcons.link),
      ),

      ///
      /// 插入列表
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatListDash,
            formatValue: '-  ',
            asNewLine: true),
        child: const ToolbarIconButton(icon: CupertinoIcons.list_dash),
      ),

      ///
      /// 插入列表带序号
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatListNumber,
            formatValue: '1.  ',
            asNewLine: true),
        child: const ToolbarIconButton(icon: CupertinoIcons.list_number),
      )
    ];
    return show ? items : [];
  }
}
