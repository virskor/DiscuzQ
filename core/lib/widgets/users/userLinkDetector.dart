import 'package:flutter/material.dart';

import 'package:core/api/users.dart';
import 'package:core/models/userGroupModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/router/route.dart';
import 'package:core/views/users/userHomeDelegate.dart';
import 'package:core/widgets/common/discuzToast.dart';

class UserLinkDetector {

  /// 用于处理使用UID打开指定用户的详情页
  const UserLinkDetector({this.context});

  final BuildContext context;

  ///
  /// Tap to show user
  Future<void> showUser({@required int uid}) async {
    if (uid == null) {
      return;
    }

    final Function close = DiscuzToast.loading();

    try {
      Map<UserModel, UserGroupModel> userInfo =
          await UsersAPI(context: context).getUserDataByID(uid: uid);

      close();

      if (userInfo == null) {
        DiscuzToast.toast(
            context: context,
            type: DiscuzToastType.failed,
            title: '打开失败',
            message: '请重新尝试');
        return;
      }

      return DiscuzRoute.navigate(
          context: context,
          widget: Builder(
            builder: (context) => UserHomeDelegate(
              forceToUpdate: false,
              user: userInfo.keys.first,
              userGroup: userInfo.values.first,
            ),
          ));
    } catch (e) {
      close();

      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '打开失败',
          message: '请重新尝试');
      throw e;
    }
  }
}
