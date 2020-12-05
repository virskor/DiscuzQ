import 'package:flutter/material.dart';

import 'package:core/api/users.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';
import 'package:core/widgets/common/discuzToast.dart';

class UserPasswordModify extends StatefulWidget {
  /// 修改用户密码
  const UserPasswordModify();

  @override
  _UserPasswordModifyState createState() => _UserPasswordModifyState();
}

class _UserPasswordModifyState extends State<UserPasswordModify> {
  /// Text editing controller
  final TextEditingController _passwordController = TextEditingController();

  /// Text editing controller
  final TextEditingController _newPasswordController = TextEditingController();

  /// Text editing controller
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DiscuzAppBar(
          title: '修改密码',
          brightness: Brightness.light,
        ),
        body: _buildBody(),
      );

  Widget _buildBody() => Padding(
        padding: kBodyPaddingAll,
        child: Column(
          children: <Widget>[
            DiscuzTextfiled(
              controller: _passwordController,
              placeHolder: '请输入旧密码',
              obscureText: true,
            ),
            DiscuzTextfiled(
              controller: _newPasswordController,
              placeHolder: '请输入新密码',
              obscureText: true,
            ),
            DiscuzTextfiled(
              controller: _newPasswordConfirmationController,
              placeHolder: '请再次确认新密码',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            DiscuzButton(
              label: '提交',
              onPressed: _modify,
            )
          ],
        ),
      );

  ///
  /// modify password
  Future<void> _modify() async {
    if (_passwordController.text.isEmpty) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '错误',
          message: '请输入旧密码');
      return;
    }

    if (_newPasswordController.text.isEmpty ||
        _newPasswordConfirmationController.text.isEmpty) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '错误',
          message: '请输入新密码');
      return;
    }

    if (_newPasswordController.text !=
        _newPasswordConfirmationController.text) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '错误',
          message: '两次输入不一致');
      return;
    }

    final dynamic attributes = {
      "password": _passwordController.text,
      "newPassword": _newPasswordController.text,
      "password_confirmation": _newPasswordConfirmationController.text,
    };

    final Function close = DiscuzToast.loading();

    try {
      final dynamic result = await UsersAPI(context: context)
          .updateProfile(attributes: attributes, context: context);

      close();

      if (result == null) {
        return;
      }

      DiscuzToast.toast(
        context: context,
        message: '密码修改成功',
        title: '成功',
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      close();
      throw e;
    }
  }
}
