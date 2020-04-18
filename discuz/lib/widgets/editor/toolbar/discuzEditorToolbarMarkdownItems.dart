import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/editor/toolbar/toolbarEvt.dart';
import 'package:discuzq/widgets/editor/toolbar/toolbarIconButton.dart';

class DiscuzEditorToolbarMarkdownItems {
  static List<Widget> markdownOpts(
      {@required bool show, Function callbackInput}) {
    final List<Widget> items = [
      ///
      /// 插入粗体字
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatBold, formatValue: '** **'),
        child: const ToolbarIconButton(icon: SFSymbols.bold),
      ),

      ///
      /// 插入斜体字
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatItalic, formatValue: '_ _'),
        child: const ToolbarIconButton(icon: SFSymbols.italic),
      ),

      ///
      /// 插入标题
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatHead, formatValue: '###  '),
        child: const ToolbarIconButton(icon: Icons.text_fields),
      ),

      /// 插入引用
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatQuote, formatValue: '>  '),
        child: const ToolbarIconButton(icon: SFSymbols.quote_bubble),
      ),

      /// 插入超链接
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatUrl, formatValue: '[ ]( )'),
        child: const ToolbarIconButton(icon: SFSymbols.link),
      ),

      ///
      /// 插入列表
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatListDash, formatValue: '-  '),
        child: const ToolbarIconButton(icon: SFSymbols.list_dash),
      ),

      ///
      /// 插入列表带序号
      GestureDetector(
        onTap: () => callbackInput(
            toolbarEvt: ToolbarEvt.formatListNumber, formatValue: '1.  '),
        child: const ToolbarIconButton(icon: SFSymbols.list_number),
      )
    ];
    return show ? items : [];
  }
}
