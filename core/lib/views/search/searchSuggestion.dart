import 'package:flutter/material.dart';

import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/ui/ui.dart';

class SearchSuggestion extends StatelessWidget {
  const SearchSuggestion();

  @override
  Widget build(BuildContext context) => SizedBox.expand(
          child: Container(
        color: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
        child: Center(
          child: const DiscuzText('暂无推荐'),
        ),
      ));
}
