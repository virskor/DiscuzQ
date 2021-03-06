import 'package:discuzq/widgets/appbar/appbarLeadings.dart';
import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/providers/appConfigProvider.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/settings/privaciesDelegate.dart';
import 'package:discuzq/widgets/common/discuzButton.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';

class PrivacyConfirm extends StatelessWidget {
  const PrivacyConfirm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      margin: const EdgeInsets.all(10),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: DiscuzApp.themeOf(context).backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: const DiscuzAppLogo(),
              ),

              /// Header
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const DiscuzText(
                    "用户协议和隐私政策",
                    isLargeText: true,
                  )),

              /// Context
              const Padding(
                  padding: const EdgeInsets.all(10),
                  child: const DiscuzText(
                      "请你务必审慎阅读、充分理解“用户协议”和“隐私政策”各条款，包括但不限于：为了更好的向你提供服务，我们需要收集你的设备标识、操作日志等信息用于分析、优化应用性能。并了解详细信息。如果你同意请点击下面按钮开始接受我们的服务。 对于发布内容监管请仔细阅读用户协议，避免滥用导致的封号等处罚。")),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      DiscuzLink(
                        label: '隐私协议',
                        onTap: () {
                          if (BuildInfo().info().privacy != "") {
                            WebviewHelper.launchUrl(
                                url: BuildInfo().info().privacy);
                            return;
                          }

                          DiscuzRoute.navigate(
                              context: context,
                              widget: const PrivaciesDelegate(
                                isPrivacy: true,
                              ));
                        },
                      ),
                      const DiscuzText('和'),
                      DiscuzLink(
                        label: '用户协议',
                        onTap: () {
                          if (BuildInfo().info().policy != "") {
                            WebviewHelper.launchUrl(
                                url: BuildInfo().info().policy);
                            return;
                          }
                          DiscuzRoute.navigate(
                              context: context,
                              widget: const PrivaciesDelegate(
                                isPrivacy: false,
                              ));
                        },
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      DiscuzButton(
                        label: "同意并继续",
                        onPressed: () async {
                          await context
                              .read<AppConfigProvider>()
                              .update(key: "confrimedPrivacy", value: true);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DiscuzButton(
                          color: Colors.blueGrey.withOpacity(.34),
                          label: "不同意",
                          onPressed: () async => DiscuzToast.show(
                              context: context, message: "欢迎再来！您只需要退出即可。"))
                    ],
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
