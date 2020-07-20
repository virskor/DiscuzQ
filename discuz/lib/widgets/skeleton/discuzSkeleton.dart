import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/skeleton/pkSkeleton.dart';

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
    return ScopedStateModelDescendant<AppState>(
        rebuildOnChange: false,
        builder: (context, child, model) {
          return model.appConf['darkTheme'] == true
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
