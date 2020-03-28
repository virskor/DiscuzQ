import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class DiscuzAppLogo extends StatelessWidget {
  final double width;
  final double height;
  final double circular;
  final double bottom;
  final bool dark;

  const DiscuzAppLogo(
      {this.width = 120,
      this.height = 50,
      this.bottom = 10,
      this.dark = false,
      this.circular = 15});
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) =>
          _buildLogo(context: context, state: state));

  ///
  /// 根据站点配置生成LOGO
  ///
  Widget _buildLogo({BuildContext context, AppState state}) {
    if (state.forum == null || state.forum.attributes.setSite.siteLogo == '') {
      return SizedBox(
          child: Image.asset(
        'assets/images/discuzapptitle.png',
        fit: BoxFit.contain,
        color: dark ? Colors.white : DiscuzApp.themeOf(context).primaryColor,
        width: width,
        height: height,
      ));
    }

    return CachedNetworkImage(
      imageUrl: state.forum.attributes.setSite.siteLogo,
      fit: BoxFit.contain,
      width: width,
      color: state.appConf['darkTheme'] ? Colors.white70 : null,
      height: height,
    );
  }
}
