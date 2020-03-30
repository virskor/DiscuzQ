import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';


import 'package:discuzq/widgets/appbar/searchAppbar.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
///
/// 搜索用户
///
class SearchUserDelegate extends StatefulWidget {
  const SearchUserDelegate();

  @override
  _SearchUserDelegateState createState() => _SearchUserDelegateState();
}

class _SearchUserDelegateState extends State<SearchUserDelegate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppbar(
        placeholder: '输入关键字搜索用户',
        onSubmit: (String keyword, bool shouldShowNoticeEmpty) {
          if (shouldShowNoticeEmpty && keyword == "") {
            DiscuzToast.failed(context: context, message: '缺少关键字');
            return;
          }
        },
      ),
      backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
    );
  }
}
