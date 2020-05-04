import 'package:discuzq/widgets/threads/payments/threadRequiredPayments.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/threadVideoModel.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/player/discuzPlayerAppbar.dart';
import 'package:discuzq/models/threadModel.dart';

class DiscuzPlayer extends StatefulWidget {
  ///
  /// 关联的视频模型
  final ThreadVideoModel video;

  final ThreadModel thread;

  const DiscuzPlayer({@required this.video, @required this.thread});

  @override
  _DiscuzPlayerState createState() => _DiscuzPlayerState();
}

class _DiscuzPlayerState extends State<DiscuzPlayer> {
  ///
  /// 是否需要支付才能播放
  bool get _requiredPaymentToPlay => widget.thread.attributes.paid ||
          double.tryParse(widget.thread.attributes.price) == 0
      ? false
      : true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ///
          /// 是否需要支付才能查看
          _requiredPaymentToPlay
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 200,
                      child: ThreadRequiredPayments(
                        thread: widget.thread,
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: const DiscuzText(
                    '正在重构播放器',
                    color: Colors.white,
                  ),
                ),
          Positioned(
            bottom: 0,
            child: DiscuzPlayerAppbar(),
          )
        ],
      ),
    );
  }
}
