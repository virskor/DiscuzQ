import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/models/threadVideoModel.dart';

class VideoAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ThreadVideoModel threadVideo;

  VideoAppbar({Key key, this.height = 150, this.threadVideo}) : super(key: key);

  @override
  _VideoAppbarState createState() => _VideoAppbarState();

  @override
  Size get preferredSize => new Size.fromHeight(height);
}

class _VideoAppbarState extends State<VideoAppbar> {
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
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.black),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -6,

              /// todo: Not recommend modify appbar leading
              child: const AppbarLeading(dark: true),
            ),
          ],
        ),
      ),
    );
  }
}
