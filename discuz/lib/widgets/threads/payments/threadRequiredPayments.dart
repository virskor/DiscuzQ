import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

class ThreadRequiredPayments extends StatelessWidget {
  ///
  /// 关联主题
  ///
  final ThreadModel thread;

  const ThreadRequiredPayments({this.thread});

  @override
  Widget build(BuildContext context) {
    if (thread.attributes.canViewPosts &&
        double.tryParse(thread.attributes.price) == 0) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: DiscuzText(
              '包含受保护的内容，暂时无权限查看',
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
