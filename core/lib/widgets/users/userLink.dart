import 'package:flutter/material.dart';

import 'package:core/models/userModel.dart';
import 'package:core/router/route.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/views/users/userHomeDelegate.dart';

class UserLink extends StatelessWidget {
  final UserModel user;

  UserLink({@required this.user});

  @override
  Widget build(BuildContext context) {
    return DiscuzLink(
      label: user.attributes.username,
      padding: const EdgeInsets.only(right: 2, top: 0, left:2, bottom: 0),
      onTap: () => DiscuzRoute.navigate(
          context: context,
          shouldLogin: true,
          widget: UserHomeDelegate(
            user: user,
          )),
    );
  }
}
