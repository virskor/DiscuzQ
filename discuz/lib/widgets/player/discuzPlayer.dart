import 'package:flutter/material.dart';

import 'package:discuzq/models/threadVideoModel.dart';
import 'package:discuzq/widgets/common/discuzCachedNetworkImage.dart';

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
      body: Center(child: DiscuzCachedNetworkImage(
        imageUrl: widget.video.attributes.coverUrl,
        fit: BoxFit.cover,
      ),),
    );
  }
}
