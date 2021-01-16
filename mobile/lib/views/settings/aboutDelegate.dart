import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/api/forum.dart';
import 'package:discuzq/providers/forumProvider.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/users/privacyBar.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class AboutDelegate extends StatefulWidget {
  const AboutDelegate({Key key}) : super(key: key);
  @override
  _AboutDelegateState createState() => _AboutDelegateState();
}

class _AboutDelegateState extends State<AboutDelegate> {
  final CancelToken _cancelToken = CancelToken();

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
    this._initForum();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  /// 如果未初始化成功
  Future<void> _initForum() async {
    if (context.read<ForumProvider>().forum != null) {
      return;
    }
    await ForumAPI(context).getForum(_cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
        builder: (BuildContext context, ForumProvider forum, Widget child) {
      return Scaffold(
        appBar: DiscuzAppBar(
          title: "关于",
        ),
        body: forum == null
            ? const Center(child: const DiscuzIndicator())
            : Column(
                children: [
                  const Expanded(
                      flex: 1,
                      child: const Center(
                        child: const DiscuzAppLogo(),
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          DiscuzText(
                            BuildInfo().info().appname,
                            fontSize: DiscuzApp.themeOf(context).largeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<PackageInfo>(
                            future: PackageInfo.fromPlatform(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              // 请求已结束
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  // 请求失败，显示错误
                                  return const DiscuzText("获取版本信息失败");
                                } else {
                                  // 请求成功，显示数据
                                  return DiscuzText(
                                      "版本: ${snapshot.data.version}+${snapshot.data.buildNumber.toString()}");
                                }
                              } else {
                                // 请求未结束，显示loading
                                return const DiscuzIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          const PrivacyBar(
                            showNotice: false,
                          ),
                        ],
                      ))
                ],
              ),
      );
    });
  }
}
