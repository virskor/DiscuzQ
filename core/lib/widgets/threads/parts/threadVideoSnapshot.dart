import 'dart:ui';

import 'package:core/router/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:core/models/threadModel.dart';
import 'package:core/models/threadVideoModel.dart';
import 'package:core/widgets/threads/threadsCacher.dart';
import 'package:core/models/postModel.dart';
import 'package:core/widgets/common/discuzCachedNetworkImage.dart';
import 'package:core/widgets/player/discuzPlayer.dart';
import 'package:flutter/rendering.dart';

///
/// _kVideoSnapshotHeight
const double _kVideoSnapshotHeight = 180;

///
/// 显示视频缩略图的组件
class ThreadVideoSnapshot extends StatelessWidget {
  ///------------------------------
  /// threadsCacher 是用于缓存当前页面的主题数据的对象
  /// 当数据更新的时候，数据会存储到 threadsCacher
  /// threadsCacher 在页面销毁的时候，务必清空 .clear()
  ///
  final ThreadsCacher threadsCacher;

  ///
  /// 主题
  ///
  final ThreadModel thread;

  ///
  /// 关联的帖子或评论
  final PostModel post;

  ThreadVideoSnapshot(
      {@required this.threadsCacher,
      @required this.thread,
      @required this.post});

  @override
  Widget build(BuildContext context) {
    ///
    /// 先获取视频信息
    /// 这个主题不包含任何的视频，所以直接返回
    ///
    if (thread.relationships.threadVideo == null) {
      return const SizedBox();
    }

    /// 查找视频ID
    final int threadVideoID =
        int.tryParse(thread.relationships.threadVideo['data']['id']);
    if (threadVideoID == 0) {
      return const SizedBox();
    }

    /// 查找视频
    /// 找不到对应的视频就放弃渲染
    /// todo: 应该提醒用户视频丢失
    final List<ThreadVideoModel> videos = threadsCacher.videos
        .where((ThreadVideoModel v) => v.id == threadVideoID)
        .toList();
    if (videos == null || videos.length == 0) {
      return const SizedBox();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: _videoContainer(context: context, video: videos[0])),
    );
  }

  ///
  /// 生成视频缩图
  ///
  Widget _videoContainer({BuildContext context, ThreadVideoModel video}) =>
      GestureDetector(
        onTap: () => _play(context: context, video: video),
        child: Container(
          alignment: Alignment.centerLeft,
          height: _kVideoSnapshotHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              DiscuzCachedNetworkImage(
                imageUrl: video.attributes.coverUrl,
                //width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/play.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () => _play(context: context, video: video),
                  )),
            ],
          ),
        ),
      );

  ///
  /// 播放视频
  ///
  Future<bool> _play(
          {@required BuildContext context, @required ThreadVideoModel video}) =>
      DiscuzRoute.navigate(
          context: context,
          widget: DiscuzPlayer(
            video: video,
            thread: thread,
          ));
}
