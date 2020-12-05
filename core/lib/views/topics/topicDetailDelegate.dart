import 'package:flutter/material.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/models/topicModel.dart';
import 'package:core/widgets/forum/forumCategoryFilter.dart';
import 'package:core/widgets/threads/theadsList.dart';
import 'package:core/api/topics.dart';
import 'package:core/widgets/common/discuzNetworkError.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/ui/ui.dart';

class TopicDetailDelegate extends StatefulWidget {
  TopicDetailDelegate({@required this.topicID}) {
    assert(topicID != null);
  }

  final int topicID;

  @override
  _TopicDetailDelegateState createState() => _TopicDetailDelegateState();
}

class _TopicDetailDelegateState extends State<TopicDetailDelegate> {
  /// states
  TopicModel _currentTopic;

  /// loading data
  bool _loading = true;

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

    this._getTopicDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
            appBar: DiscuzAppBar(
              title: _appbarTitle,
               brightness: Brightness.light,
              centerTitle: true,
              bottom: _currentTopic == null
                  ? null
                  : _BuilderAppbarBottom(
                      topic: _currentTopic,
                    ),
            ),
            body: _buildBody(),
          );

  ///
  /// Create appbar title
  String get _appbarTitle =>
      _loading ? '正在加载话题..' : "#${_currentTopic.attributes.content}#";

  /// Show threads
  /// 未成功加载话题详情时，暂不显示话题列表，直到加载完成后
  bool get _showThreads => _loading == null || _loading ? false : true;

  Widget _buildBody() => _loading == false && _currentTopic == null
      ? DiscuzNetworkError(
          onRequestRefresh: _getTopicDetail,
        )
      : Column(
          children: <Widget>[
            !_showThreads
                ? const SizedBox()
                : Expanded(
                    child: ThreadsList(
                      topicID: widget.topicID,

                      /// 初始化的时候，用户没有选择，则默认使用第一个筛选条件
                      filter: ForumCategoryFilter.conditions[0],
                    ),
                  )
          ],
        );

  /// 获取话题详情
  Future<void> _getTopicDetail() async {
    setState(() {
      _loading = true;
    });

    final Function close = DiscuzToast.loading();

    try {
      final TopicModel topic =
          await TopicsAPI(context: context).getTopic(id: widget.topicID);

      close();

      if (topic == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      setState(() {
        _currentTopic = topic;
        _loading = false;
      });
    } catch (e) {
      close();
      setState(() {
        _loading = false;
      });
      throw e;
    }
  }
}

class _BuilderAppbarBottom extends StatelessWidget with PreferredSizeWidget {
  _BuilderAppbarBottom({this.topic});

  final TopicModel topic;

  @override
  Size get preferredSize => Size.fromHeight(30);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSpan(context,
                label: '热度', number: topic.attributes.viewCount),
            const SizedBox(
              width: 15,
            ),
            _buildSpan(context,
                label: '内容', number: topic.attributes.threadCount),
          ],
        ),
      );

  Widget _buildSpan(BuildContext context, {int number, String label}) =>
      Container(
        child: Row(
          children: <Widget>[
            DiscuzText(
              "$label：",
              fontSize: DiscuzApp.themeOf(context).normalTextSize,
            ),
            DiscuzText(
              number.toString(),
              fontFamily: 'Roboto Condensed',
              fontWeight: FontWeight.bold,
              fontSize: DiscuzApp.themeOf(context).mediumTextSize,
            ),
          ],
        ),
      );
}
