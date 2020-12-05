import 'package:core/core.dart';
import 'package:flutter/material.dart';
/*
 * 现在DiscuzQ for Flutter app 核心的组件位于
 * ./packages/core
 * 
 * 后续这里只将涉及原生API调用管理，组件开发，请移步 
 */
void main() {
  /// ensure app initialized
  WidgetsFlutterBinding.ensureInitialized();

  runDiscuzApp();
}
