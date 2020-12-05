import 'package:flutter/material.dart';

import 'package:core/router/route.dart';
import 'package:core/views/users/loginDelegate.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/common/discuzText.dart';

class YetNotLogon extends StatelessWidget {
  
  const YetNotLogon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
              child: const DiscuzText(
            '登录来使用更多',
            textScaleFactor: 1.8,
            fontWeight: FontWeight.bold,
          )),
          const Center(child: const DiscuzText('您的账号已经退出，快登录吧')),
          const SizedBox(height: 30),
          DiscuzButton(
            label: '登录来继续',
            onPressed: () => DiscuzRoute.navigate(
                context: context, widget: const LoginDelegate()),
          )
        ],
      ),
    );
  }
}
