import 'package:flutter/material.dart';

import 'package:discuzq/router/route.dart';
import 'package:discuzq/router/routers.dart';
import 'package:discuzq/widgets/search/customSearchDelegate.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/search/searchActionButton.dart';
import 'package:discuzq/widgets/search/searchTypeItemsColumn.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class DiscuzExploreHeader extends StatefulWidget {
  const DiscuzExploreHeader({Key key}) : super(key: key);
  @override
  _DiscuzExploreHeaderState createState() => _DiscuzExploreHeaderState();
}

class _DiscuzExploreHeaderState extends State<DiscuzExploreHeader>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
        child: Container(
            child: Row(
              children: <Widget>[
                _exploreSelection(
                  icon: "assets/images/moments.png",
                  label: '搜动态',
                  onTap: () => showDiscuzSearch(
                      context: context,
                      delegate: DiscuzAppSearchDelegate(
                          type: DiscuzAppSearchType.thread)),
                ),
                _exploreSelection(
                  icon: "assets/images/account.png",
                  label: '搜用户',
                  onTap: () => showDiscuzSearch(
                      context: context,
                      delegate: DiscuzAppSearchDelegate(
                          type: DiscuzAppSearchType.user)),
                ),
                _exploreSelection(
                  icon: "assets/images/chat.png",
                  label: "搜话题",
                  onTap: () {
                    DiscuzRoute.navigate(
                        context: context, path: Routers.topics);
                  },
                ),
              ],
            )));
  }

  Widget _exploreSelection({
    @required Function onTap,
    @required String icon,
    String label = "未知",
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.082),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(5)),
                    ),
                    child: Image.asset(
                      icon,
                      width: 40,
                    )),
                const SizedBox(
                  height: 5,
                ),
                DiscuzText(
                  label,
                  isSmallText: true,
                  isGreyText: true,
                ),
              ],
            ),
          ),
        ),
      );
}
