import 'package:flutter/material.dart';

import 'package:core/models/topicModel.dart';
import 'package:core/widgets/threads/threadsCacher.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/router/route.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/htmRender/htmlRender.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/views/topics/topicDetailDelegate.dart';
import 'package:core/widgets/threads/parts/threadGalleriesSnapshot.dart';

class TopicCard extends StatefulWidget {
  TopicCard({Key key, this.threadsCacher, this.topic}) : super(key: key);

  ///------------------------------
  /// threadsCacher 是用于缓存当前页面的主题数据的对象
  final ThreadsCacher threadsCacher;

  ///
  /// thread
  /// 主题
  ///
  final TopicModel topic;

  @override
  _TopicCardState createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.topic.relationships.lastThread == null) {
      return const SizedBox();
    }

    final int threadID =
        int.tryParse(widget.topic.relationships.lastThread['id']) ?? 0;
    if (threadID == 0) {
      return const SizedBox();
    }

    final List<ThreadModel> _thread = widget.threadsCacher.threads
        .where((ThreadModel it) => it.id == threadID)
        .toList();
    if (_thread.length == 0) {
      return const SizedBox();
    }

    final int postID =
        int.tryParse(_thread[0].relationships.firstPost['data']['id']) ?? 0;
    if (postID == 0) {
      return const SizedBox();
    }

    // /// 查找firstPost
    final List<PostModel> _firstPost = widget.threadsCacher.posts
        .where((PostModel it) => it.id == postID)
        .toList();

    if (_firstPost.length == 0) {
      return const SizedBox();
    }

    return RepaintBoundary(
      child: GestureDetector(
        child: Container(
            margin: const EdgeInsets.only(top: 5),
            padding: kMarginAllContent,
            decoration: BoxDecoration(
              border: const Border(top: Global.border, bottom: Global.border),
              color: DiscuzApp.themeOf(context).backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ///
                /// 渲染话题标题
                DiscuzText(
                  '#${widget.topic.attributes.content}#',
                  fontSize: DiscuzApp.themeOf(context).largeTextSize,
                  fontWeight: FontWeight.bold,
                  //color: DiscuzApp.themeOf(context).greyTextColor,
                ),
                ///
                /// 渲染内容
                HtmlRender(
                  html: _firstPost[0].attributes.contentHtml,
                ),
                ///
                /// 渲染图片
                ThreadGalleriesSnapshot(
                  firstPost: _firstPost[0],
                  thread: _thread[0],
                  threadsCacher: widget.threadsCacher,
                ),
                ///
                /// 渲染话题热度
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      DiscuzText(
                        '热度${widget.topic.attributes.viewCount.toString()}',
                        color: DiscuzApp.themeOf(context).greyTextColor,
                      ),
                      const SizedBox(width: 10),
                      DiscuzText(
                        '内容${widget.topic.attributes.threadCount.toString()}',
                        color: DiscuzApp.themeOf(context).greyTextColor,
                      ),
                    ],
                  ),
                )
              ],
            )),
        onTap: () => DiscuzRoute.navigate(
          context: context,
          widget: Builder(
              builder: (context) => TopicDetailDelegate(
                    topicID: widget.topic.id,
                  )),
        ),
      ),
    );
  }
}
