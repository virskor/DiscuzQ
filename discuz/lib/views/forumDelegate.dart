import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/forum/floatLoginButton.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/forum/forumCategoryTab.dart';
import 'package:discuzq/widgets/forum/forumAddButton.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/search/searchColumnDialog.dart';

/// 论坛首页
class ForumDelegate extends StatefulWidget {
  const ForumDelegate({Key key}) : super(key: key);

  @override
  _ForumDelegateState createState() => _ForumDelegateState();
}

class _ForumDelegateState extends State<ForumDelegate>
    with AutomaticKeepAliveClientMixin {
  ///
  /// _showAppbar
  /// 是否隐藏appbar
  bool _showAppbar = true;

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

    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) => Scaffold(
              appBar: _showAppbar
                  ? DiscuzAppBar(
                      centerTitle: true,
                      title: const Center(child: const DiscuzAppLogo(dark: true,)),
                      backgroundColor: DiscuzApp.themeOf(context).primaryColor,
                      brightness: Brightness.dark,
                      leading: IconButton(
                        icon: const DiscuzIcon(
                          SFSymbols.search,
                          color: Colors.white,
                        ),
                        onPressed: () => SearchColumnDialog.show(context),
                      ),
                      actions: <Widget>[
                        const ForumAddButton(
                          awalysDark: true,
                        )
                      ],
                    )
                  : null,

              /// 用户未登录时也不显示floatingActionButton
              floatingActionButton: _showAppbar || state.user == null
                  ? null
                  : FloatingActionButton(
                      elevation: 0,
                      backgroundColor: DiscuzApp.themeOf(context).primaryColor,
                      child: const ForumAddButton(
                        awalysDark: true,
                      ),
                      onPressed: () => null,
                    ),
              drawerEdgeDragWidth: Global.drawerEdgeDragWidth,
              body: Stack(
                fit: StackFit.expand,
                overflow: Overflow.clip,
                children: <Widget>[
                  /// 显示论坛分类和分类下内容列表
                  state.forum == null
                      ? const SizedBox()
                      : ForumCategoryTab(
                          onAppbarState: (bool show) {
                            ///
                            /// 过滤相同的状态，避免UI重新Build
                            ///
                            if (_showAppbar == show) {
                              return;
                            }
                            setState(() {
                              _showAppbar = show;
                            });
                          },
                        ),

                  /// 显示底部悬浮登录提示组件
                  Positioned(
                    bottom: 20,
                    width: MediaQuery.of(context).size.width,
                    child: AnimatedOpacity(
                      opacity: _showAppbar ? 1 : 0,
                      duration: Duration(milliseconds: 270),
                      child: const FloatLoginButton(),
                    ),
                  )
                ],
              ),
            ));
  }
}
