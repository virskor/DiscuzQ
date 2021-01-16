import 'package:flutter/material.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

class ReportHistoryDelegate extends StatefulWidget {
  const ReportHistoryDelegate();
  @override
  _ReportHistoryDelegateState createState() => _ReportHistoryDelegateState();
}

class _ReportHistoryDelegateState extends State<ReportHistoryDelegate> {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: DiscuzAppBar(
          title: '我的投诉举报',
          
        ),
        body: const Center(
          child: const DiscuzText('暂无记录'),
        ),
      );
}
