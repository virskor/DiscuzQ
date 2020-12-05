import 'package:flutter/material.dart';

import 'package:core/widgets/forum/floatLoginButton.dart';
import 'package:core/widgets/forum/forumCategoryTab.dart';

/// 论坛首页
class ForumDelegate extends StatefulWidget {
  const ForumDelegate({Key key}) : super(key: key);

  @override
  _ForumDelegateState createState() => _ForumDelegateState();
}

class _ForumDelegateState extends State<ForumDelegate>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        overflow: Overflow.clip,
        children: <Widget>[
          /// 显示论坛分类和分类下内容列表
          ForumCategoryTab(
            onAppbarState: (bool show) {},
          ),

          /// 显示底部悬浮登录提示组件
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: const FloatLoginButton(),
          )
        ],
      ),
    );
  }
}
