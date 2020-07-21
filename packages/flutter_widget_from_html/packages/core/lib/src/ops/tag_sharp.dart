part of '../core_widget_factory.dart';

class _TagSharp {
  final WidgetFactory wf;

  _TagSharp(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (NodeMetadata meta, el) {
          final attrs = el.attributes;
          final id = attrs.containsKey('id') ? attrs['id'] : null;
          if (id == null) {
            return [kCssTextDecoration, kCssTextDecoration];
          }

          final styles = [
            kCssTextDecoration,
            kCssTextDecoration,
          ];

          if (wf.hyperlinkColor != null) {
            styles.addAll([
              kCssColor,
              convertColorToHex(wf.hyperlinkColor),
            ]);
          }

          return styles;
        },
        onPieces: (meta, pieces) {
          final onTap = _buildGestureTapCallback(meta);
          if (onTap == null) return pieces;

          return pieces.map(
            (piece) => piece.hasWidgets
                ? BuiltPieceSimple(
                    widgets: IWidgetPlaceholder.wrap(
                        piece.widgets, wf.buildGestureDetectors, wf, onTap),
                  )
                : _buildBlock(piece, onTap),
          );
        },
      );

  BuiltPiece _buildBlock(BuiltPiece piece, GestureTapCallback onTap) => piece
    ..block.rebuildBits((b) => b is WidgetBit
        ? b.rebuild(
            child: GestureDetector(
              child: b.widgetSpan.child,
              onTap: onTap,
            ),
          )
        : b is DataBit ? b.rebuild(onTap: onTap) : b);

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final id = attrs.containsKey('id') ? attrs['id'] : null;
    if (id == null || id != 'topic' && id != 'member') {
      return wf.buildGestureTapCallbackForSharpUrl(0);
    }

    /// @someone
    if (id == 'member') {
      final value = attrs.containsKey('value') ? attrs['value'] : null;
      return wf.buildGestureTapCallbackForUserAt(int.tryParse(value));
    }

    final value = attrs.containsKey('value') ? attrs['value'] : null;
    return wf.buildGestureTapCallbackForSharpUrl(int.tryParse(value));
  }
}
