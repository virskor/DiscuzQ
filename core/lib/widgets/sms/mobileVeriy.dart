import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';

enum MobileVerifyTypes {
  ///
  /// 注册/登录
  login,

  ///
  /// 绑定手机号
  bind,

  ///
  /// 重绑手机号
  rebind,

  ///
  /// 重设登录密码
  resetPWD,

  ///
  /// 重设支付密码
  resetPayPWD,

  ///
  /// 验证手机号是否为当前用户（可不传手机号，但必须传 Token）
  verify
}

///
/// 短信验证服务
class DiscuzSMS {
  const DiscuzSMS({@required this.context});

  final BuildContext context;

  ///
  /// MobileVerifyTypes 转化为对应的字符串
  static const Map<MobileVerifyTypes, String> _typesValue = {
    MobileVerifyTypes.login: 'login',
    MobileVerifyTypes.rebind: 'rebind',
    MobileVerifyTypes.bind: 'bind',
    MobileVerifyTypes.resetPWD: 'reset_pwd',
    MobileVerifyTypes.resetPayPWD: 'reset_pay_pwd',
    MobileVerifyTypes.verify: 'verify',
  };

  /// 使用 MobileVerifyTypes 获取对应的字符串
  String _mapMobileVerifyTypesString(MobileVerifyTypes type) =>
      _typesValue[type];

  ///
  /// send
  /// 发送短信验证码
  ///
  /// mobile 目标手机号
  /// type 短信验证码类型
  Future<bool> send(
      {@required String mobile,
      MobileVerifyTypes type = MobileVerifyTypes.login}) async {
    final Function close = DiscuzToast.loading();

    try {
      final dynamic data = {
        "data": {
          "attributes": {
            "mobile": mobile,
            "type": _mapMobileVerifyTypesString(type)
          }
        }
      };

      final Response resp = await Request(context: context)
          .postJson(url: "${Urls.sms}/send", data: data);

      close();

      if (resp == null) {
        return Future.value(false);
      }

      ///
      /// request 自动处理了200
      return Future.value(true);
    } catch (e) {
      close();
      throw (e);
    }
  }

  ///
  /// verify
  /// 验证短信验证码合法性
  ///
  /// code 用户接收到的验证码，必填
  Future<dynamic> verify(String code,
      {

      ///
      /// 手机号
      /// type == verify 验证手机号是否为当前用户（可不传手机号，但必须传 Token）
      ///
      /// code 用户接收到的验证码值
      String mobile,

      /// 验证类型
      /// 必选
      @required MobileVerifyTypes type,

      /// password
      /// 类型为 reset_pwd 时必须
      ///
      /// pay_password
      /// 类型为 reset_pay_pwd 时必须
      ///
      /// pay_password_confirmation
      /// 类型为 reset_pay_pwd 时必须
      ///
      /// inviteCode
      /// 类型为 login 时 可传邀请码进行邀请注册
      String password,
      payPassword,
      payPasswordConfirmation,
      inviteCode}) async {
    ///
    /// 校验数据完整
    if (type == MobileVerifyTypes.resetPWD && password.isEmpty) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '发送失败',
          message: '缺少密码');
      return;
    }

    if (type == MobileVerifyTypes.resetPayPWD &&
        (payPassword.isEmpty || payPasswordConfirmation.isEmpty)) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '发送失败',
          message: '支付密码或请再次确认');
      return;
    }

    if (type == MobileVerifyTypes.resetPayPWD &&
        (payPassword != payPasswordConfirmation)) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '发送失败',
          message: '支付密码或请再次确认');
      return;
    }

    dynamic attributes = {
      "mobile": mobile,
      "code": code,
      "type": _mapMobileVerifyTypesString(type)
    };

    ///
    /// 为不同类型，添加不同的请求参数
    ///
    /// 重置密码
    if (type == MobileVerifyTypes.resetPWD) {
      attributes.addAll({"password": password});
    }

    ///
    /// 重置支付密码
    if (type == MobileVerifyTypes.resetPayPWD) {
      attributes.addAll({
        "pay_password": payPassword,
        "pay_password_confirmation": payPasswordConfirmation
      });
    }

    /// 类型为 login 时 可传邀请码进行邀请注册
    if (type == MobileVerifyTypes.login) {
      attributes.addAll({"inviteCode": inviteCode});
    }

    final dynamic data = {
      "data": {"attributes": attributes}
    };

    /// loading
    final Function close = DiscuzToast.loading();

    /// 发送
    try {
      final Response resp = await Request(context: context)
          .postJson(url: "${Urls.sms}/verify", data: data);

      close();

      if (resp == null) {
        return Future.value(null);
      }

      return Future.value(resp.data['data']);
    } catch (e) {
      
      close();
      throw e;
    }
  }
}
