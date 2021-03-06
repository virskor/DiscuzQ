import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/skeleton/pkSkeleton.dart';
import 'package:discuzq/providers/appConfigProvider.dart';

class DiscuzSkeleton extends StatelessWidget {
  final int length;
  final bool isCircularImage;
  final bool isBottomLinesActive;

  const DiscuzSkeleton(
      {Key key,
      this.length = 10,
      this.isCircularImage = true,
      this.isBottomLinesActive = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppConfigProvider>(
        builder: (BuildContext context, AppConfigProvider conf, Widget child) {
      return ListView.builder(
          itemCount: length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return conf.appConf['darkTheme'] == true
                ? PKDarkCardSkeleton(
                    isCircularImage: isCircularImage,
                    isBottomLinesActive: isBottomLinesActive,
                  )
                : PKCardSkeleton(
                    isCircularImage: isCircularImage,
                    isBottomLinesActive: isBottomLinesActive,
                  );
          });
    });
  }
}
