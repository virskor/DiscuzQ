import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/widgets/skeleton/pkSkeleton.dart';
import 'package:core/providers/appConfigProvider.dart';

class DiscuzSkeleton extends StatelessWidget {
  final int length;
  final bool isCircularImage;
  final bool isBottomLinesActive;

  const DiscuzSkeleton(
      {Key key,
      this.length = 10,
      this.isCircularImage = false,
      this.isBottomLinesActive = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppConfigProvider>(
        builder: (BuildContext context, AppConfigProvider conf, Widget child) {
      return conf.appConf['darkTheme'] == true
          ? PKDarkCardListSkeleton(
              isCircularImage: isCircularImage,
              isBottomLinesActive: isBottomLinesActive,
              length: length,
            )
          : PKCardListSkeleton(
              isCircularImage: isCircularImage,
              isBottomLinesActive: isBottomLinesActive,
              length: length,
            );
    });
  }
}
