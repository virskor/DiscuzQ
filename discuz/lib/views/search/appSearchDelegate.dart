import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/widgets/search/searchTypeItemsColumn.dart';

class AppSearchDelegate extends StatefulWidget {
  const AppSearchDelegate();
  @override
  _AppSearchDelegateState createState() => _AppSearchDelegateState();
}

class _AppSearchDelegateState extends State<AppSearchDelegate> {
   @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Scaffold(
            appBar: DiscuzAppBar(
              title: '搜索',
            ),
            body: const SearchTypeItemsColumn()
                  
          ));

}