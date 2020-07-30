import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/utils/authHelper.dart';

class FloatLoginButton extends StatelessWidget {
  const FloatLoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) {
        if (state.user != null) {
          return SizedBox();
        }
        return Center(
          child: SizedBox(
            width: 200,
            child: MaterialButton(
              color: DiscuzApp.themeOf(context).primaryColor,
              child: const DiscuzText('登录/注册', color: Colors.white),
              onPressed: () => AuthHelper.login(context: context),
            ),
          ),
        );
      });
}
