import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/device.dart';

///
/// 这个组件基于pull_to_refresh 但担心如果后续更改其他控件所以重新封装下
class DiscuzRefresh extends StatelessWidget {
  ///
  /// refreshController
  ///
  final RefreshController controller;

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
      this.child,
      this.enablePullUp = false});

  @override
  Widget build(BuildContext context) => SmartRefresher(
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        header: const WaterDropHeader(),
        /// 允许乡下加载
        // header: WaterDropHeader(),
        controller: controller,
        onRefresh: () {
          Device.emitVibration();
          onRefresh();
        },
        onLoading: () {
          Device.emitVibration();
          onLoading();
        },
        child: child,
      );
}
