import 'package:flutter/material.dart';

import 'package:discuzq/models/threadVideoModel.dart';
import 'package:discuzq/widgets/common/discuzCachedNetworkImage.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/player/discuzPlayerAppbar.dart';

class DiscuzPlayer extends StatefulWidget {
  final ThreadVideoModel video;

  const DiscuzPlayer({this.video});

  @override
  _DiscuzPlayerState createState() => _DiscuzPlayerState();
}

class _DiscuzPlayerState extends State<DiscuzPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: DiscuzCachedNetworkImage(
              imageUrl: widget.video.attributes.coverUrl,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: DiscuzText(
              '正在重构播放器',
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            child: DiscuzPlayerAppbar(),
          )
        ],
      ),
    );
  }
}
