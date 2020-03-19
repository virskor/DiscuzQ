import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAmount.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class WalletDelegate extends StatefulWidget {
  const WalletDelegate({Key key}) : super(key: key);
  @override
  _WalletDelegateState createState() => _WalletDelegateState();
}

class _WalletDelegateState extends State<WalletDelegate> {
  static const _borderRadius = const BorderRadius.all(Radius.circular(10));

  /// state
  /// is _loading data
  bool _loading = true;

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
              actions: <Widget>[
                _loading
                    ? const Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: const DiscuzIndicator(
                          brightness: Brightness.dark,
                        ))
                    : const SizedBox()
              ],
            ),
            backgroundColor: DiscuzApp.themeOf(context).primaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 100),

                  ///
                  /// 显示钱包残额
                  _amount(model),

                  ///
                  /// 钱包详情，提现等
                  ClipRRect(
                    borderRadius: _borderRadius,
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 40, left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: _borderRadius,
                          color: DiscuzApp.themeOf(context).backgroundColor),
                      child: Column(
                        children: <Widget>[
                          ///
                          /// 冻结金额
                          ///
                          _frozen(model),
                          DiscuzListTile(
                            title: DiscuzText('提现记录'),
                          ),
                          DiscuzListTile(
                            title: DiscuzText('钱包明细'),
                          ),
                          DiscuzListTile(
                            title: DiscuzText('订单明细'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));

  ///
  /// 冻结金额
  ///
  Widget _frozen(AppModel model) => DiscuzListTile(
        title: DiscuzText('冻结金额'),
        trailing: DiscuzText(
          '0.00',
          color: DiscuzApp.themeOf(context).greyTextColor,
        ),
      );

  ///
  /// show amounts
  Widget _amount(AppModel model) => Center(
        child: DiscuzAmount(
          amount: "123.00",
          textScaleFactor: 4,
        ),
      );
}
