import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tencentplayer/flutter_tencentplayer.dart';
import 'package:discuzq/models/threadVideoModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/player/tencentPlayerBottomNav.dart';
import 'package:discuzq/widgets/player/tencentPlayerLoading.dart';
import 'package:discuzq/widgets/player/discuzPlayerRightSider.dart';


class DiscuzPlayer extends StatefulWidget {
  ///
  /// 要播放的视频
  ///
  final ThreadVideoModel video;

  ///
  /// 关联的帖子或评论
  final PostModel post;

  DiscuzPlayer({@required this.video, @required this.post});

  @override
  _DiscuzPlayerState createState() => _DiscuzPlayerState();
}

class _DiscuzPlayerState extends State<DiscuzPlayer> {
  TencentPlayerController _controller;
  VoidCallback _listener;

  _DiscuzPlayerState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  initState() {
    super.initState();

    ///
    /// 进入播放器，去除状态栏
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    _controller = TencentPlayerController.network(
        widget.video.attributes.mediaUrl,
        playerConfig: PlayerConfig(
          headers: {
            "Referer": Global.domain,
          },
          autoPlay: true,
          supportBackground: false,
        ))
      //_controller = TencentPlayerController.asset('static/tencent1.mp4')
      //_controller = TencentPlayerController.file('/storage/emulated/0/test.mp4')
      //_controller = TencentPlayerController.network(null, playerConfig: {auth: {"appId": 1252463788, "fileId": '4564972819220421305'}})
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    ///
    /// 销毁时要还原状态栏
    ///
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          //// AspectRatio 为了保证整个手机屏幕沾满
          _controller.value.initialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: TencentPlayer(_controller),
                  ),
                )
              : Center(
                  child: Image.network(widget.video.attributes.coverUrl),
                ),

          ///
          /// 顶部导航条
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: DiscuzAppBar(
                  title: '视频',
                  dark: true,
                  brightness: Brightness.dark,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),

          ///
          /// 右侧作者栏
          /// 包含作者，点赞按钮，评论条数
          // Positioned(
          //   right: 5,
          //   bottom: 200,
          //   child: DiscuzPlayerRightSider(
          //     post: widget.post,
          //   ),
          // ),

          TencentPlayerBottomWidget(
            isShow: true,
            controller: _controller,
            showClearBtn: false,
            behavingCallBack: () {
              //delayHideCover();
            },
            changeClear: (int index) {
              //changeClear(index);
            },
          ),

          Center(
            child: TencentPlayerLoading(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}
