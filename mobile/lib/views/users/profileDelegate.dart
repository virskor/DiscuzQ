import 'package:discuzq/views/users/profiles/userPasswordModify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/profiles/userSignatureDelegate.dart';
import 'package:discuzq/views/users/profiles/usernameModifyDelegate.dart';
import 'package:discuzq/widgets/common/avatarPicker.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/settings/settingGroupWrapper.dart';
import 'package:discuzq/providers/userProvider.dart';

class ProfileDelegate extends StatefulWidget {
  const ProfileDelegate({Key key}) : super(key: key);
  @override
  _ProfileDelegateState createState() => _ProfileDelegateState();
}

class _ProfileDelegateState extends State<ProfileDelegate> {
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
  Widget build(BuildContext context) => Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider user, Widget child) =>
            Scaffold(
          appBar: DiscuzAppBar(
            title: '我的资料',
            brightness: Brightness.light,
          ),
          body: Column(
            children: <Widget>[
              SettingGroupWrapper(
                label: '个人档案',
                children: <Widget>[
                  DiscuzListTile(
                    title: const DiscuzText('头像'),
                    trailing: AvatarPicker(
                      avatar: DiscuzAvatar(
                        size: 40,
                      ),
                    ),
                  ),
                  DiscuzListTile(
                    title: const DiscuzText('用户名'),
                    trailing: !user.user.attributes.canEditUsername
                        ? DiscuzText(user.user.attributes.username)
                        : const SizedBox(),
                    onTap: () {
                      if (!user.user.attributes.canEditUsername) {
                        return false;
                      }

                      return DiscuzRoute.navigate(
                          context: context,
                          fullscreenDialog: true,
                          shouldLogin: true,
                          widget: Builder(
                              builder: (BuildContext context) =>
                                  const UsernameModifyDelegate()));
                    },
                  ),
                  DiscuzListTile(
                    title: const DiscuzText('个性签名'),
                    onTap: () => DiscuzRoute.navigate(
                        context: context,
                        fullscreenDialog: true,
                        shouldLogin: true,
                        widget: Builder(
                            builder: (BuildContext context) =>
                                const UserSignatureDelegate())),
                  ),
                  DiscuzListTile(
                    title: const DiscuzText('修改密码'),
                    onTap: () => DiscuzRoute.navigate(
                        context: context,
                        fullscreenDialog: true,
                        shouldLogin: true,
                        widget: Builder(
                            builder: (BuildContext context) =>
                                const UserPasswordModify())),
                  ),
                  // DiscuzListTile(
                  //   title: const DiscuzText('钱包密码'),
                  //   onTap: () =>
                  //       DiscuzToast.failed(context: context, message: '暂不支持'),
                  // ),
                ],
              )
            ],
          ),
        ),
      );
}
