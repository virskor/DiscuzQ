import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzText.dart';

class DiscuzNoMoreData extends StatelessWidget {
  
  const DiscuzNoMoreData();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const DiscuzText('没有更多了'),
    );
  }
}
