import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';

class PrivaciesDelegate extends StatefulWidget {
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

    /// 加载协议资源
    this._loadAssets();
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
            title: widget.isPrivacy ? '隐私政策' : '用户协议',
          )));

  ///
  /// todo: 加载协议资源
  /// notice: 加载用户设置的隐私协议，或者默认的协议
  /// Global.privacyUri Global.policiesUri 优先级是最高的
  /// 如果上面的用户设置了，则加载上面的Uri， 如果没有则加载默认的协议
  Future<void> _loadAssets() async {}
}
