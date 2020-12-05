import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

import 'package:core/states/scopedState.dart';
import 'package:core/states/appState.dart';
import 'package:core/widgets/appbar/appbarExt.dart';

class PrivaciesDelegate extends StatefulWidget {
  ///
  /// isPrivacy == true 打开的将是隐私政策 否则 是用户条款
  final bool isPrivacy;

  const PrivaciesDelegate({Key key, this.isPrivacy = true}) : super(key: key);
  @override
  _PrivaciesDelegateState createState() => _PrivaciesDelegateState();
}

class _PrivaciesDelegateState extends State<PrivaciesDelegate> {
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
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) {
        final String _text = widget.isPrivacy
            ? (state.forum.attributes.agreements.privacyContent ?? "暂未设置")
            : (state.forum.attributes.agreements.registerContent ?? "暂未设置");
        return Scaffold(
            appBar: DiscuzAppBar(
              title: widget.isPrivacy ? '隐私政策' : '用户协议',
              brightness: Brightness.light,
            ),
            body: Column(
              children: [
                /// 显示内容
                Expanded(
                  child: Padding(
                    padding: kBodyPaddingAll,
                    child: SingleChildScrollView(
                      child: DiscuzText(_text),
                    ),
                  ),
                )
              ],
            ));
      });
}
