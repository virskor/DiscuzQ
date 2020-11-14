import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/follows/followerListDelegate.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';

class FollowingDelegate extends StatefulWidget {
  const FollowingDelegate({Key key}) : super(key: key);
  @override
  _FollowingDelegateState createState() => _FollowingDelegateState();
}

class _FollowingDelegateState extends State<FollowingDelegate> {
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
              title: '我的关注',
            ),
            body: SingleChildScrollView(
              child: SettingGroupWrapper(
                label: '关注的用户和粉丝',
                children: <Widget>[
                  DiscuzListTile(
                    title: const DiscuzText('我关注的人'),
                    onTap: () => DiscuzRoute.navigate(
                        shouldLogin: true,
                        context: context,
                        widget: const FollowerListDelegate(
                          isToUser: true,
                        )),
                  ),
                  const DiscuzDivider(
                    padding: 0,
                  ),
                  DiscuzListTile(
                    title: const DiscuzText('关注我的人'),
                    onTap: () => DiscuzRoute.navigate(
                        shouldLogin: true,
                        context: context,
                        widget: const FollowerListDelegate(
                          isToUser: false,
                        )),
                  ),
                ],
              ),
            ),
          ));
}
