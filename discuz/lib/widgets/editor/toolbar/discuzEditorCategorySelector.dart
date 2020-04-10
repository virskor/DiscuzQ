import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/widgets/categories/discuzCaytegories.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class DiscuzEditorCategorySelector extends StatefulWidget {
  ///
  /// 用户改变了选中的分类
  /// onChanged(CategoryModel category){
  ///
  /// }
  final Function onChanged;

  ///
  /// 默认选中的分类
  final CategoryModel defaultCategory;

  DiscuzEditorCategorySelector({Key key, this.onChanged, this.defaultCategory});
  @override
  _DiscuzEditorCategorySelectorState createState() =>
      _DiscuzEditorCategorySelectorState();
}

class _DiscuzEditorCategorySelectorState
    extends State<DiscuzEditorCategorySelector> {
  ///
  /// state
  ///

  ///
  /// 分类的列表
  List<CategoryModel> _categories = [];

  ///
  /// 当前选中的分类
  CategoryModel _selectedCategory;

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    _prepare(); /// 记得在supe.initState前执行，否则UI将无法完成默认选中的绑定
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// build 分类选取的组件
    return Container(
      padding: const EdgeInsets.all(5),
      child: _buidPicker(),
    );
  }

  ///
  /// 初始化时，完成自动选择
  /// 
  void _prepare() async{
    await _getCategories();
    if(widget.defaultCategory != null){
      _selectedCategory = widget.defaultCategory;
    }
  }


  ///
  /// 创建选择器组件
  ///
  Widget _buidPicker() => FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: _selectedCategory == null
            ? DiscuzText('请选择分类')
            : DiscuzText(
                _selectedCategory.attributes.name,
                color: DiscuzApp.themeOf(context).primaryColor,
              ),
        onPressed: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: DiscuzApp.themeOf(context).backgroundColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: DiscuzText(
                        '选择要发布的分类',
                        fontWeight: FontWeight.bold,
                        textScaleFactor: 1.3,
                      ),
                    ),
                    const DiscuzDivider(
                      padding: 0,
                    ),
                    Expanded(
                      child: ListView(
                        children: _categories
                            .map((c) => DiscuzListTile(
                                  title: DiscuzText(c.attributes.name),
                                  trailing: _selectedCategory == c
                                      ? const DiscuzIcon(
                                          SFSymbols.checkmark_circle_fill)
                                      : const DiscuzListTileTrailing(),
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = c;
                                    });

                                    if (widget.onChanged != null) {
                                      widget.onChanged(c);
                                    }

                                    Navigator.pop(context);
                                  },
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              );
            }),
      );

  ///
  /// 获取分类的列表
  ///
  Future<void> _getCategories() async {
    List<CategoryModel> categories =
        await DiscuzCategories(context: context).getCategories();

    setState(() {
      _categories = categories;
    });
  }
}
