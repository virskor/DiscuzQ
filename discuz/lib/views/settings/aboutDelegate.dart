import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/settings/aboutAppFooter.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';

class AboutDelegate extends StatefulWidget {
  const AboutDelegate({Key key}) : super(key: key);
  @override
  _AboutDelegateState createState() => _AboutDelegateState();
}

class _AboutDelegateState extends State<AboutDelegate> {
  /// state
  PackageInfo _packageInfo;

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
    Future.delayed(Duration(milliseconds: 400))
        .then((_) => this._getPackageInfo());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '关于APP',
            ),
            backgroundColor: DiscuzApp.themeOf(context).backgroundColor,

            /// 这里直接使用一致的颜色
            body: RepaintBoundary(
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    bottom: 10,
                    child: const AboutAppFooter(),
                  ),

                  ///
                  /// app logo
                  ListView(
                    padding: const EdgeInsets.only(top: 100),
                    children: <Widget>[
                      SizedBox(
                          width: 120,
                          child: state.forum.attributes.setSite.siteLogo == ''
                              ? const DiscuzAppLogo()
                              : CachedNetworkImage(
                                  imageUrl:
                                      state.forum.attributes.setSite.siteLogo,
                                )),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: DiscuzText(
                          state.forum.attributes.setSite.siteName,
                          fontWeight: FontWeight.bold,
                          fontSize: DiscuzApp.themeOf(context).mediumTextSize,
                        ),
                      ),
                      Center(
                        child: _buildPackageInfoNitice(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));

  ///
  /// 版本信息
  Widget _buildPackageInfoNitice() {
    if (_packageInfo == null) {
      return const DiscuzIndicator();
    }

    return Container(
      child: DiscuzText(
          '版本信息： ${_packageInfo.version}+${_packageInfo.buildNumber}'),
    );
  }

  ///
  /// 获取APP package信息
  Future<void> _getPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
