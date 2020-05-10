import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';

class DiscuzPlayerAppbar extends StatefulWidget implements PreferredSizeWidget {
  ///
  /// 指定appbar高度
  /// 默认50
  ///
  final double height;

  DiscuzPlayerAppbar({this.height = 50});
  @override
  Size get preferredSize => new Size.fromHeight(height);

  @override
  _DiscuzPlayerAppbarState createState() => _DiscuzPlayerAppbarState();
}

class _DiscuzPlayerAppbarState extends State<DiscuzPlayerAppbar> {
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
    return SafeArea(
      top: true,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
        child: Row(
          children: <Widget>[
            const _BackButton(),
          ],
        ),
      ),
    );
  }
}

///
/// 返回按钮
class _BackButton extends StatelessWidget {
  const _BackButton();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 45,
        height: 45,
        child: DiscuzIcon(
          SFSymbols.arrow_uturn_left,
          color: Colors.white,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
