import 'package:flutter/material.dart';

class DiscuzEditorCategorySelector extends StatefulWidget {
  ///
  /// 用户改变了选中的分类
  /// onChanged(CategoryModel category){
  ///
  /// }
  final Function onChanged;

  DiscuzEditorCategorySelector({this.onChanged});
  @override
  _DiscuzEditorCategorySelectorState createState() =>
      _DiscuzEditorCategorySelectorState();
}

class _DiscuzEditorCategorySelectorState
    extends State<DiscuzEditorCategorySelector> {
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
    return Container();
  }
}
