import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/common/discuzDivider.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzAmount.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzIndicater.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/models/walletModel.dart';
import 'package:core/models/userModel.dart';
import 'package:core/providers/userProvider.dart';

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
  WalletModel _wallet = WalletModel();

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
  Widget build(BuildContext context) =>  Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider user, Widget child) => Scaffold(
            appBar: DiscuzAppBar(
              brightness: Brightness.dark,
              backgroundColor: DiscuzApp.themeOf(context).primaryColor,
              title: '我的钱包',
              actions: <Widget>[
                _loading
                    ? const Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: const DiscuzIndicator(
                          brightness: Brightness.dark,
                        ))
                    : const SizedBox()
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 100),

                  ///
                  /// 显示钱包残额
                  _amount(),

                  ///
                  /// 钱包详情，提现等
                  ClipRRect(
                    borderRadius: _borderRadius,
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 40, left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: _borderRadius,
                          color: DiscuzApp.themeOf(context).backgroundColor),
                      child: Column(
                        children: <Widget>[
                          ///
                          /// 冻结金额
                          ///
                          _frozen(),
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
  Widget _frozen() => DiscuzListTile(
        title: DiscuzText('冻结金额'),
        trailing: DiscuzText(
          _wallet.freezeAmount,
          color: DiscuzApp.themeOf(context).greyTextColor,
        ),
      );

  ///
  /// show amounts
  Widget _amount() => Center(
        child: DiscuzAmount(
          amount: _wallet.availableAmount,
          textScaleFactor: 4,
        ),
      );

  ///
  /// 仅刷新状态
  /// 页面initState 和 _refreshMessageList 都会刷新状态
  Future<void> _refreshWallet() async {
    setState(() {
      _loading = true;
    });

    ///
    /// 视图请求 接口的最新数据
    ///
    ///
    final UserModel user = context.read<UserProvider>().user;
    final String userWalletUrl = "${Urls.usersWallerData}/${user.attributes.id}";
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
      _wallet = WalletModel.fromMap(maps: resp.data['data']['attributes']);
    });
  }
}
