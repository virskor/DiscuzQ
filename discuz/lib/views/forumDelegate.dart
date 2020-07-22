import 'package:flutter/material.dart';

import 'package:discuzq/widgets/forum/floatLoginButton.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/forum/forumCategoryTab.dart';
import 'package:discuzq/states/scopedState.dart';

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
    if(!mounted){
      return const SizedBox();
    }
    
    super.build(context);
    

    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: true,
        builder: (context, child, state) => Scaffold(
              body: Stack(
                fit: StackFit.expand,
                overflow: Overflow.clip,
                children: <Widget>[
                  /// 显示论坛分类和分类下内容列表
                  state.forum == null
                      ? const SizedBox()
                      : ForumCategoryTab(
                          onAppbarState: (bool show) {
                          },
                        ),

                  /// 显示底部悬浮登录提示组件
                  Positioned(
                    bottom: 20,
                    width: MediaQuery.of(context).size.width,
                    child: const FloatLoginButton(),
                  )
                ],
              ),
            ));
  }
}
