// import 'package:core/utils/global.dart';
// import 'package:core/utils/sounds.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:core/utils/device.dart';

///
/// 这个组件基于pull_to_refresh 但担心如果后续更改其他控件所以重新封装下
class DiscuzRefresh extends StatelessWidget {
  ///
  /// refreshController
  ///
  final RefreshController controller;

  ///
  /// ScrollController
  /// 滑动控制
  final ScrollController scrollController;

  ///
  /// enablePullDown
  /// 是否允许刷新操作
  ///
  final bool enablePullDown;

  ///
  /// enablePullUp
  /// 是否允许加载更多页面
  ///
  final bool enablePullUp;

  ///
  ///  onRefresh
  final Function onRefresh;

  ///
  /// onLoading
  final Function onLoading;

  ///
  /// child to display
  ///
  final Widget child;

  DiscuzRefresh(
      {@required this.controller,
      this.enablePullDown = false,
      this.onLoading,
      this.onRefresh,
      this.scrollController,
      this.child,
      this.enablePullUp = false});

  @override
  Widget build(BuildContext context) => Scrollbar(
        isAlwaysShown: false,
        child: SmartRefresher(
          enablePullDown: enablePullDown,
          enablePullUp: enablePullUp,
          header: const WaterDropHeader(),
          footer: const ClassicFooter(),
          scrollController: scrollController,

          /// 允许乡下加载
          // header: WaterDropHeader(),
          controller: controller,
          onRefresh: () {
            FlutterDevice.emitVibration();
            // Sounds.play(Sounds.refresh);
            onRefresh();
          },
          onLoading: () {
            FlutterDevice.emitVibration();
            // Sounds.play(Sounds.refresh);
            onLoading();
          },
          child: child,
        ),
      );
}
