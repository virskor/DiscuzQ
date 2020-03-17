import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/utils/authHelper.dart';

class FloatLoginButton extends StatelessWidget {
  const FloatLoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: true,
      builder: (context, child, model) {
        if (model.user != null) {
          return SizedBox();
        }

        return Center(
          child: SizedBox(
            width: 200,
            child: FlatButton(
              color: DiscuzApp.themeOf(context).primaryColor,
              child: const DiscuzText('登录/注册', color: Colors.white),
              onPressed: () => AuthHelper.login(context: context),
            ),
          ),
        );
      });
}
