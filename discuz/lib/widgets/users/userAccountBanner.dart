import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class UserAccountBanner extends StatefulWidget {
  const UserAccountBanner();
  
  @override
  _UserAccountBannerState createState() => _UserAccountBannerState();
}

class _UserAccountBannerState extends State<UserAccountBanner> {
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, state) => GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DiscuzAvatar(),

                ///
                const SizedBox(height: 20),

                /// 用户名
                DiscuzText(
                  state.user.attributes.username,
                  fontSize: DiscuzApp.themeOf(context).largeTextSize,
                  fontWeight: FontWeight.bold,
                ),

                /// 手机号
                DiscuzText(
                  state.user.attributes.signature.isNotEmpty
                      ? state.user.attributes.signature
                      : '未设置签名',
                  color: DiscuzApp.themeOf(context).greyTextColor,
                )
              ],
            ),
          ),
          onTap: () => DiscuzRoute.open(
              context: context,
              shouldLogin: true,
              widget: UserHomeDelegate(
                user: state.user,
              )),
        ),
      );
}
