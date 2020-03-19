import 'package:dio/dio.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAmount.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/urls.dart';
import 'package:discuzq/widgets/common/discuzIndicater.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

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

  ///
  /// wallet data
  ///
  dynamic _wallet;

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

    Future.delayed(Duration(milliseconds: 450))
        .then((_) async => await _refreshWallet());
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
                          const DiscuzDivider(),
                          DiscuzListTile(
                            title: DiscuzText('提现记录'),
                          ),
                          const DiscuzDivider(),
                          DiscuzListTile(
                            title: DiscuzText('钱包明细'),
                          ),
                          const DiscuzDivider(),
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
          _wallet == null ? '0.00' : _wallet['attributes']['freeze_amount'],
          color: DiscuzApp.themeOf(context).greyTextColor,
        ),
      );

  ///
  /// show amounts
  Widget _amount(AppModel model) => Center(
        child: DiscuzAmount(
          amount:
              _wallet == null ? '0.00' : _wallet['attributes']['freeze_amount'],
          textScaleFactor: 4,
        ),
      );

  ///
  /// 仅刷新状态
  /// 页面initState 和 _refreshMessageList 都会刷新状态
  Future<void> _refreshWallet({AppModel model}) async {
    if (model == null) {
      try {
        model = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      _loading = true;
    });

    ///
    /// 视图请求 接口的最新数据
    ///
    ///
    final String userWalletUrl = "${Urls.usersWallerData}/${model.user['id']}";
    Response resp = await Request(context: context).getUrl(url: userWalletUrl);

    if (resp == null) {
      setState(() {
        _loading = false;
      });

      DiscuzToast.failed(context: context, message: '加载失败');
      return;
    }

    /// 更新钱包状态
    ///
    setState(() {
      _loading = false;
      _wallet = resp.data['data'];
    });
  }
}
