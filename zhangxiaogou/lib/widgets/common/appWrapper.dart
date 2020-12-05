import 'package:flutter/material.dart';

class AppWrapper extends StatefulWidget {
  ///
  /// 初始化钩子
  /// 
  final Function onInit;

  ///
  /// app销毁的钩子
  /// 
  final Function onDispose;

  ///
  /// child
  /// APP
  final Widget child;

  AppWrapper(
      {@required this.onInit, @required this.child, @required this.onDispose});
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  /*
   * @description: before create application
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-08 16:45:25
   */
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  /*
   * @description: dispose callback
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-08 16:45:11
   */
  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
