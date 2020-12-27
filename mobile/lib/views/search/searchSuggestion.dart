import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class SearchSuggestion extends StatelessWidget {
  const SearchSuggestion();

  @override
  Widget build(BuildContext context) => SizedBox.expand(
          child: Container(
        color: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
        child: const Center(
          child: const DiscuzText('暂无推荐'),
        ),
      ));
}
