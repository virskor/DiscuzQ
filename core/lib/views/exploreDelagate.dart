import 'package:flutter/material.dart';

import 'package:core/router/route.dart';
import 'package:core/router/routers.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/search/searchActionButton.dart';
import 'package:core/widgets/search/searchTypeItemsColumn.dart';
import 'package:core/widgets/ui/ui.dart';

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
      body: Container(
          decoration: BoxDecoration(
              border: const Border(bottom: Global.border),
              color: DiscuzApp.themeOf(context).backgroundColor),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              DiscuzListTile(
                title: const DiscuzText(
                  '搜索主题',
                ),
                onTap: () => showSearch(
                    context: context,
                    delegate: DiscuzAppSearchDelegate(
                        type: DiscuzAppSearchType.thread)),
              ),
              DiscuzListTile(
                title: const DiscuzText(
                  '搜索用户',
                ),
                onTap: () => showSearch(
                    context: context,
                    delegate: DiscuzAppSearchDelegate(
                        type: DiscuzAppSearchType.user)),
              ),
              DiscuzListTile(
                title: const DiscuzText(
                  '话题',
                ),
                onTap: () {
                  DiscuzRoute.navigate(context: context, path: Routers.topics);
                },
              )
            ],
          )),
    );
  }
}
