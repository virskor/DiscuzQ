import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'package:core/models/buildInfoModel.dart';
import 'package:core/utils/device.dart';

///
/// 注意，这应该是一个单例，这样以来可以避免重复加载yaml的过程，而直接访问内存降低性能压力
class BuildInfo {
  factory BuildInfo() => _getInstance();
  static BuildInfo get instance => _getInstance();
  static BuildInfo _instance;
  BuildInfo._internal() {
    // initial
  }

  static BuildInfo _getInstance() {
    if (_instance == null) {
      _instance = BuildInfo._internal();
    }
    return _instance;
  }

  ///
  ///
  /// 一次存储后，即丢在内存中
  BuildInfoModel _buildInfo;

  ///
  /// Yaml
  String _yaml = '';

  ///
  /// 异步初始化
  /// 在APP开始的时候完成
  ///
  Future<void> init() =>
      rootBundle.loadString('build.yaml').then((value) => _yaml = value);

  ///
  /// 获取不同运行环境下的配置文件
  ///
  BuildInfoModel info() {
    ///
    /// 如果已经读取过，则不再继续读取
    if (_buildInfo != null) {
      return _buildInfo;
    }

    final String mode = FlutterDevice.isDevelopment ? 'development' : 'production';
    var yml = loadYaml(_yaml);
    if (yml[mode] == null) {
      return const BuildInfoModel();
    }

    final BuildInfoModel buildInfo = BuildInfoModel.fromMap(maps: yml[mode]);

    /// 存储以便下次直接使用
    _buildInfo = buildInfo;

    return buildInfo;
  }
}
