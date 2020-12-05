import 'dart:convert';
import 'package:flutter/material.dart';

class WalletModel {
  ///
  /// user_id
  /// 用户ID
  ///
  final int userID;

  ///
  /// available_amount
  /// 可用金额
  ///
  final String availableAmount;

  ///
  /// freeze_amount
  /// 冻结金额
  ///
  final String freezeAmount;

  ///
  /// wallet_status
  /// 钱包状态
  ///
  final dynamic walletStatus;

  ///
  /// cash_tax_ratio
  /// 费率
  ///
  final dynamic cashTaxRatio;

  const WalletModel(
      {this.userID,
      this.availableAmount = "0.00",
      this.freezeAmount = "0.00",
      this.cashTaxRatio = 0.00,
      this.walletStatus = 1});

  ///
  /// fromMap
  /// 转换模型
  /// 
  static WalletModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const WalletModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return WalletModel(
        userID: data['user_id'] ?? 0,
        availableAmount: data['available_amount'] ?? '0.00',
        freezeAmount: data['freeze_amount'] ?? '0.00',
        cashTaxRatio: data['cash_tax_ratio'] ?? 0,
        walletStatus: data['wallet_status'] ?? 1);
  }
}
