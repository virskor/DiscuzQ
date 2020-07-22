import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/views/accountDelegate.dart';
import 'package:discuzq/views/forumDelegate.dart';
import 'package:discuzq/widgets/bottomNavigator/bottomNavigator.dart';
import 'package:discuzq/views/notificationsDelegate.dart';
import 'package:discuzq/widgets/common/discuzNetworkError.dart';
import 'package:discuzq/widgets/forum/bootstrapForum.dart';
import 'package:discuzq/views/search/appSearchDelegate.dart';

class Discuz extends StatefulWidget {
  const Discuz({Key key}) : super(key: key);

  @override
  _DiscuzState createState() => _DiscuzState();
}

class _DiscuzState extends State<Discuz> {
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
  Widget build(BuildContext context) {
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: true,
        builder: (context, child, state) {
          return DiscuzApp(
              theme: _buildTheme(state),
              child: MaterialApp(
                  title: Global.appname,
                  debugShowCheckedModeBanner:
                      BuildInfo().info().debugShowCheckedModeBanner,

                  /// 如果用户在Build.yaml禁止了这项，这直接不要允许开启
                  showPerformanceOverlay:
                      BuildInfo().info().enablePerformanceOverlay
                          ? state.appConf['showPerformanceOverlay']
                          : false,
                  localizationsDelegates: [
                    // this line is important
                    RefreshLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate
                  ],
                  supportedLocales: [
                    const Locale('zh', 'CH'),
                    const Locale('en', 'US'),
                  ],
                  localeResolutionCallback:
                      (Locale locale, Iterable<Locale> supportedLocales) {
                    //print("change language");
                    return locale;
                  },
                  onGenerateRoute: (RouteSettings settings) {
                    switch (settings.name) {
                      case '/':
                        return MaterialWithModalsPageRoute(
                            builder: (_) => Builder(

                                /// 不在 MaterialApp 使用theme属性
                                /// 这里rebuild的时候会有问题，所以使用Theme去包裹
                                /// 其实在MaterialApp里直接用theme也可以，但是flutter rebuild的时候有BUG， scaffoldBackgroundColor并未更新
                                /// 这样会造成黑暗模式切换时有问题
                                builder: (BuildContext context) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          boldText: false,
                                          textScaleFactor:
                                              state.appConf['fontWidthFactor']),
                                      child: const _DiscuzAppDelegate(),
                                    )),
                            settings: settings);
                    }
                    return MaterialPageRoute(
                      builder: (context) => Container(),
                    );
                  }));
        });
  }

  // build discuz app theme
  DiscuzTheme _buildTheme(AppState state) => state.appConf['darkTheme']
      ? DiscuzTheme(
          primaryColor: Color(state.appConf['themeColor']),
          textColor: Global.textColorDark,
          greyTextColor: Global.greyTextColorDark,
          scaffoldBackgroundColor: Global.scaffoldBackgroundColorDark,
          backgroundColor: Global.backgroundColorDark,
          brightness: Brightness.dark)
      : DiscuzTheme(
          primaryColor: Color(state.appConf['themeColor']),
        );
}

///
/// 这里相当于一个Tabbar，托管了一些顶级页面的views
/// 并包含bottom navigator，全局的drawer等
///
///
class _DiscuzAppDelegate extends StatefulWidget {
  const _DiscuzAppDelegate({Key key}) : super(key: key);
  @override
  __DiscuzAppDelegateState createState() => __DiscuzAppDelegateState();
}

class __DiscuzAppDelegateState extends State<_DiscuzAppDelegate> {
  /// 页面集合
  static const List<Widget> _views = [
    const ForumDelegate(),
    const AppSearchDelegate(),
    const NotificationsDelegate(),
    const AccountDelegate()
  ];

  /// 底部按钮菜单
  final List<NavigatorItem> _items = [
    const NavigatorItem(icon: 0xe63e),
    const NavigatorItem(icon: 0xe605, shouldLogin: true),
    const NavigatorItem(icon: 0xe677, shouldLogin: true),
    const NavigatorItem(icon: 0xe7c7, size: 23, shouldLogin: true)
  ];

  /// 使用global key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// states
  int _selected = 0;

  /// _loaded means user forum api already requested! not means success or fail to load data
  bool _loaded = false;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    this._getForumData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Theme(
            data: Theme.of(context).copyWith(
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: DiscuzApp.themeOf(context).primaryColor,
                backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
                //platform: TargetPlatform.iOS,
                scaffoldBackgroundColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor,
                canvasColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor),
            child: Scaffold(
              key: _scaffoldKey,
              body: _buildAppElement(state),
              resizeToAvoidBottomPadding: false,
              bottomNavigationBar: DiscuzBottomNavigator(
                items: _items,
                onItemSelected: (index) => setState(() {
                  _selected = index;
                }),
              ),
            ),
          ));

  /// 创建网络错误提示组件，尽在加载失败的时候提示
  Widget _buildAppElement(AppState state) => _loaded && state.forum == null
      ? Center(
          child: DiscuzNetworkError(
            onRequestRefresh: () => _getForumData(force: true),
          ),
        )
      : _views.elementAt(_selected);

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
