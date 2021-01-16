import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/search/customSearchDelegate.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/router/route.dart';
import 'package:discuzq/router/routers.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/search/searchActionButton.dart';
import 'package:discuzq/widgets/search/searchTypeItemsColumn.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class ExploreDelegate extends StatefulWidget {
  const ExploreDelegate();

  @override
  _ExploreDelegateState createState() => _ExploreDelegateState();
}

class _ExploreDelegateState extends State<ExploreDelegate>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: DiscuzAppBar(
        title: "发现",
      ),
      body: ListView(
        children: <Widget>[
          _exploreSelection(
            child: DiscuzListTile(
              leading: const DiscuzIcon(0xe69b),
              title: const DiscuzText(
                '搜索主题',
              ),
              onTap: () => showDiscuzSearch(
                  context: context,
                  delegate: DiscuzAppSearchDelegate(
                      type: DiscuzAppSearchType.thread)),
            ),
          ),
          _exploreSelection(
            child: DiscuzListTile(
              leading: const DiscuzIcon(0xe6e7),
              title: const DiscuzText(
                '搜索用户',
              ),
              onTap: () => showDiscuzSearch(
                  context: context,
                  delegate:
                      DiscuzAppSearchDelegate(type: DiscuzAppSearchType.user)),
            ),
          ),
          _exploreSelection(
              child: DiscuzListTile(
            leading: const DiscuzIcon(0xe8b1),
            title: const DiscuzText(
              '话题',
            ),
            onTap: () {
              DiscuzRoute.navigate(context: context, path: Routers.topics);
            },
          )),
        ],
      ),
    );
  }

  Widget _exploreSelection({Widget child}) => Container(
        decoration:
            BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
        child: child,
      );
}
