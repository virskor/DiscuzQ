import 'dart:async';

import 'package:flutter/material.dart';

import 'package:discuzq/api/sms.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:discuzq/utils/device.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';

/// 仅发送验证码
class SendSMSField extends StatefulWidget {
  const SendSMSField(
      {Key key, @required this.type, @required this.mobile, this.onChanged})
      : super(key: key);

  final Function onChanged;

  final String mobile;

  final MobileVerifyTypes type;

  @override
  _SendSMSFieldState createState() => _SendSMSFieldState();
}

class _SendSMSFieldState extends State<SendSMSField> {
  /// 计时器
  int _counter = 0;

  /// 最大计数
  static const int _maxCounter = FlutterDevice.isDevelopment ? 10 : 60;

  ///
  final Duration _duration = const Duration(seconds: 1);

  /// 标签
  String get label =>
      _counter == 0 ? "发送验证码" : "${(_maxCounter - _counter).toString()}秒后重发";

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
  Widget build(BuildContext context) {
    final Widget _field = Stack(
      children: [
        DiscuzTextfiled(
          placeHolder: "请输入验证码",
          borderWidth: .2,
          borderColor: const Color(0x3F000000),
          inputType: TextInputType.phone,
          removeBottomMargin: true,
          label: "验证码",
          maxLength: 6,
          onChanged: (String val) {
            widget.onChanged(val);
          },
        ),
        Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              child: Row(
                children: [
                  const SizedBox(
                    width: 1,
                    height: 15,
                    child: const DecoratedBox(
                      decoration:
                          const BoxDecoration(color: const Color(0x3F000000)),
                    ),
                  ),

                  /// 发送短信验证码
                  FlatButton(
                    child: DiscuzText(
                      label,
                      primary: true,
                    ),
                    onPressed: _counter == 0 ? _sendCode : null,
                  )
                ],
              ),
            ))
      ],
    );

    return _field;
  }

  /// 发送短信验证码
  Future<void> _sendCode() async {
    try {
      final bool result = await SMSApi(context: context)
          .send(mobile: widget.mobile ?? "", type: widget.type);

      if (!result) {
        DiscuzToast.show(context: context, message: "发送失败");
        return;
      }

      Timer.periodic(_duration, (Timer t) {
        if (_counter >= (_maxCounter - 1)) {
          t.cancel();

          setState(() {
            _counter = 0;
          });
          return;
        }

        setState(() {
          _counter++;
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
