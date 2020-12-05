import 'package:flutter/material.dart';

import 'package:core/router/route.dart';
import 'package:core/views/settings/privaciesDelegate.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/widgets/common/discuzText.dart';

class PrivacyBar extends StatelessWidget {

  const PrivacyBar();

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const DiscuzText(
              '如您继续代表您同意',
            ),
            DiscuzLink(
              label: '隐私协议',
              onTap: () => DiscuzRoute.navigate(
                  context: context,
                  widget: const PrivaciesDelegate(
                    isPrivacy: true,
                  )),
            ),
            const DiscuzText('和'),
            DiscuzLink(
              label: '用户协议',
              onTap: () => DiscuzRoute.navigate(
                  context: context,
                  widget: const PrivaciesDelegate(
                    isPrivacy: false,
                  )),
            ),
          ],
        ),
      );
}