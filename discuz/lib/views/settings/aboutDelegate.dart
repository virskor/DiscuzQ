import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/settings/aboutAppFooter.dart';

class AboutDelegate extends StatefulWidget {
  const AboutDelegate({Key key}) : super(key: key);
  @override
  _AboutDelegateState createState() => _AboutDelegateState();
}

class _AboutDelegateState extends State<AboutDelegate> {
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width: 200,
                            child: state.forum.attributes.setSite.siteLogo == ''
                                ? const DiscuzAppLogo()
                                : CachedNetworkImage(
                                    imageUrl:
                                        state.forum.attributes.setSite.siteLogo,
                                  )),
                        const SizedBox(
                          height: 50,
                        ),
                        DiscuzText(
                          state.forum.attributes.setSite.siteName,
                          fontWeight: FontWeight.bold,
                          textScaleFactor: 2,
                        ),

                        ///
                        /// Flutter DiscuzQ是免费的，但你需要声明使用
                        /// 如果移除版权信息，你可能面临诉讼
                        const DiscuzText('基于DiscuzQ和Flutter for DiscuzQ'),
                        const SizedBox(
                          height: 20,
                        ),
                        DiscuzButton(
                          color: Colors.transparent,
                          labelColor: DiscuzApp.themeOf(context).primaryColor,
                          label: '查看更多站点信息',
                          onPressed: () => WebviewHelper.launchUrl(
                              url: "${Global.domain}/circle-info"),
                        )
                      ],
                    ),
                  )

                  ///_buildBody(),
                ],
              ),
            ),
          ));
}
