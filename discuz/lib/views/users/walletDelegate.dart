import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAmount.dart';

class WalletDelegate extends StatefulWidget {
  const WalletDelegate({Key key}) : super(key: key);
  @override
  _WalletDelegateState createState() => _WalletDelegateState();
}

class _WalletDelegateState extends State<WalletDelegate> {
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
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => Scaffold(
            appBar: DiscuzAppBar(
              dark: true,
              brightness: Brightness.dark,
              backgroundColor: DiscuzApp.themeOf(context).primaryColor,
              title: '我的钱包',
            ),
            backgroundColor: DiscuzApp.themeOf(context).primaryColor,
            body: Column(
              children: <Widget>[
                const SizedBox(height: 100),
                ///
                /// 显示钱包残额
                _amount(model)
              ],
            ),
          ));

  ///
  /// show amounts
  Widget _amount(AppModel model) => Center(
        child: DiscuzAmount(
          amount: model.user['attributes']['walletBalance'],
          textScaleFactor: 4,
        ),
      );
}
