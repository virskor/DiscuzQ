import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

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
      appBar: DiscuzAppBar(
        title: '搜索用户',
      ),
    );
  }
}
