import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/widgets/explore/discuzExploreHeader.dart';
import 'package:discuzq/providers/categoriesProvider.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/threads/categoryThreadsListDelegate.dart';
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
    return Consumer<CategoriesProvider>(
        builder: (BuildContext context, CategoriesProvider cats, Widget child) {
      return Scaffold(
        appBar: DiscuzAppBar(
          title: "发现与节点",
        ),
        body: Scrollbar(
          child: ListView.builder(
              itemCount: cats.fakeSecondaryTab.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (cats.fakeSecondaryTab[index] == null ||
                    cats.fakeSecondaryTab[index].isEmpty) {
                  return const SizedBox();
                }

                final List<CategoryModel> _relatedCategories = cats.exploreCats
                    .where((element) =>
                        element.attributes.description ==
                        cats.fakeSecondaryTab[index])
                    .toList();

                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: DiscuzText(
                          cats.fakeSecondaryTab[index],
                          isLargeText: true,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: index == 0
                            ? const DiscuzExploreHeader()
                            : const SizedBox(),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Column(
                                  children: _relatedCategories
                                      .map(
                                        (e) => Container(
                                          decoration: BoxDecoration(
                                              color: DiscuzApp.themeOf(context)
                                                  .backgroundColor),
                                          child: DiscuzListTile(
                                            dense: true,
                                            title: DiscuzText(
                                              e.attributes.name,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                            subtitle: DiscuzText(
                                              "动态：${e.attributes.threadCount.toString()}",
                                              isGreyText: true,
                                              isSmallText: true,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            onTap: () {
                                              DiscuzRoute.navigate(
                                                  context: context,
                                                  widget:
                                                      CategoryThreadListDelegate(
                                                          category: e));
                                            },
                                          ),
                                        ),
                                      )
                                      .toList())))
                    ],
                  ),
                );
              }),
        ),
      );
    });
  }
}
