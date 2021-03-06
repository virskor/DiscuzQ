import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/providers/userProvider.dart';

class UserAccountBanner extends StatefulWidget {
  const UserAccountBanner();

  @override
  _UserAccountBannerState createState() => _UserAccountBannerState();
}

class _UserAccountBannerState extends State<UserAccountBanner> {
  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider user, Widget child) =>
            GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DiscuzAvatar(
                  size: 100,
                ),

                ///
                const SizedBox(height: 20),

                /// 用户名
                DiscuzText(
                  user.user.attributes.username,
                  isLargeText: true,
                  fontWeight: FontWeight.bold,
                ),

                /// 手机号
                DiscuzText(
                  user.user.attributes.signature.isNotEmpty
                      ? user.user.attributes.signature
                      : '未设置签名',
                  color: DiscuzApp.themeOf(context).greyTextColor,
                )
              ],
            ),
          ),
          onTap: () => DiscuzRoute.navigate(
              context: context,
              shouldLogin: true,
              widget: UserHomeDelegate(
                user: user.user,
              )),
        ),
      );
}
