import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';

class UserLink extends StatelessWidget {
  final UserModel user;

  UserLink({@required this.user});

  @override
  Widget build(BuildContext context) {
    return DiscuzLink(
      label: user.username,
      padding: const EdgeInsets.only(right: 2, top: 0, left:2, bottom: 0),
      onTap: () => DiscuzRoute.open(
          context: context,
          shouldLogin: true,
          widget: UserHomeDelegate(
            user: user,
          )),
    );
  }
}
