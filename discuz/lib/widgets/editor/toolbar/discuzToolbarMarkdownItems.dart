import 'package:discuzq/widgets/editor/toolbar/toolbarIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class DiscuzToolbarMarkdownItems {
  static List<Widget> markdownOpts(
      {@required bool show, Function callbackInput}) {
    final List<Widget> items = [
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'bold'),
        child: const ToolbarIconButton(icon: Icons.format_bold),
      ),
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'italic'),
        child: const ToolbarIconButton(icon: Icons.format_italic),
      ),
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'format_title'),
        child: const ToolbarIconButton(icon: Icons.title),
      ),
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'format_quote'),
        child: const ToolbarIconButton(icon: Icons.format_quote),
      ),
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'list_dash'),
        child: const ToolbarIconButton(icon: SFSymbols.list_dash),
      ),
      GestureDetector(
        onTap: () => callbackInput(toolbarEvt: 'list_number'),
        child: const ToolbarIconButton(icon: SFSymbols.list_number),
      )
    ];
    return show ? items : [];
  }
}
