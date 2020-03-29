import 'package:flutter/material.dart';
import 'package:flutter_tencentplayer/flutter_tencentplayer.dart';

import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
///
/// TencentPlayerLoading
/// 
class TencentPlayerLoading extends StatelessWidget {
  final TencentPlayerController controller;
  final double scale;

  TencentPlayerLoading({this.controller, this.scale = 3});

  @override
  Widget build(BuildContext context) {
    String tip = '';
    if (!controller.value.initialized &&
        controller.value.errorDescription == null) {
      tip = '加载中...';
    } else if (controller.value.errorDescription != null) {
      tip = controller.value.errorDescription;
    } else if (controller.value.isLoading) {
      tip = '${controller.value.netSpeed}kb/s';
    }
    if (!controller.value.initialized ||
        controller.value.errorDescription != null ||
        controller.value.isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DiscuzIndicator(
            scale: this.scale,
          ),
          const SizedBox(
            height: 38,
          ),
          DiscuzText(
            tip,
            color: Colors.white,
          )
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
