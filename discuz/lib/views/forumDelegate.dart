import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/forum/floatLoginButton.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/common/discuzNetworkError.dart';
import 'package:discuzq/widgets/forum/bootstrapForum.dart';
import 'package:discuzq/widgets/forum/forumCategoryTab.dart';
import 'package:discuzq/widgets/forum/forumAddButton.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/views/totalSearchDelegate.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';

/// 论坛首页
class ForumDelegate extends StatefulWidget {
  const ForumDelegate({Key key}) : super(key: key);

  @override
  _ForumDelegateState createState() => _ForumDelegateState();
}

class _ForumDelegateState extends State<ForumDelegate>
    with AutomaticKeepAliveClientMixin {
  /// states
  /// _loaded means user forum api already requested! not means success or fail to load data
  bool _loaded = false;

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
    this._getForumData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: true,
        builder: (context, child, state) => Scaffold(
              appBar: _showAppbar
                  ? DiscuzAppBar(
                      elevation: 0,
                      centerTitle: true,
                      title: const Center(
                          child: const DiscuzAppLogo(
                        color: Colors.transparent,
                      )),
                      leading: IconButton(
                        icon: DiscuzIcon(
                          SFSymbols.search,
                          color: DiscuzApp.themeOf(context).textColor,
                        ),
                        onPressed: () => DiscuzRoute.open(
                            context: context,
                            widget: const TotalSearchDelegate()),
                      ),
                      actions: _actions(context),
                    )
                  : null,
              floatingActionButton: _showAppbar
                  ? null
                  : FloatingActionButton(
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

                  /// 是否显示网络错误组件
                  _buildNetwordError(state),

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

  /// 创建网络错误提示组件，尽在加载失败的时候提示
  Widget _buildNetwordError(AppState state) => _loaded && state.forum == null
      ? Center(
          child: DiscuzNetworkError(
            onRequestRefresh: () => _getForumData(force: true),
          ),
        )
      : const SizedBox();

  /// forum actions
  List<Widget> _actions(BuildContext context) => [
        Row(
          children: <Widget>[
            // 搜索
            const ForumAddButton()
            // 弹出菜单
          ],
        )
      ];

  /// 获取论坛启动信息
  /// force 为true时，会忽略_loaded
  /// 如果在初始化的时候将loaded设置为true, 则会导致infinite loop
  Future<void> _getForumData({bool force = false}) async {
    /// 避免重复加载
    if (_loaded && !force) {
      return;
    }

    await BootstrapForum(context).getForum();

    /// 加载完了就可以将_loaded 设置为true了其实，因为_loaded只做是否请求过得判断依据
    setState(() {
      _loaded = true;
    });
  }
}
