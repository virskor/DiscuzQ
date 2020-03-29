import 'package:discuzq/models/threadVideoModel.dart';

///
/// 引用了腾讯云超级播放器SDK
/// https://pub.dev/packages/flutter_tencentplayer_plus
///
import 'package:flutter/material.dart';

class DiscuzPlayer extends StatefulWidget {
  final ThreadVideoModel video;

  DiscuzPlayer({@required this.video});
  
  @override
  _DiscuzPlayerState createState() => _DiscuzPlayerState();
}

class _DiscuzPlayerState extends State<DiscuzPlayer> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
