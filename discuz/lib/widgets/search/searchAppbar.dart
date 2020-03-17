import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzTextfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  final Function onSubmit;

  SearchAppbar({this.contentHeight = 45, this.onSubmit});

  @override
  _SearchAppbarState createState() => _SearchAppbarState();

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class _SearchAppbarState extends State<SearchAppbar> {
  final TextEditingController _controller = TextEditingController();

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// todo: 优化，仅在初始化设置即可
    SystemChrome.setSystemUIOverlayStyle(
        DiscuzApp.themeOf(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return Container(
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
              child: DiscuzTextfiled(
                controller: _controller,
                placeHolder: '输入关键字搜索',
                borderColor: Colors.transparent,
                bottomMargin: 6,
                borderWidth: 0.1,
                textInputAction: TextInputAction.search,
                onSubmit: (String val) {
                  if (widget.onSubmit != null) {
                    widget.onSubmit(val);
                  }
                },
              ),
            ),

            /// ...搜索按钮
            _searchButton()
          ],
        ),
      ),
    );
  }

  ///
  /// 搜索按钮
  /// 实际上用户输入的过程中会请求搜索接口，但是呢点击按钮也执行一次
  /// 避免有的用户觉得突兀
  /// 点击按钮的时候要移除输入框焦点
  /// 
  Widget _searchButton() => Positioned(
        right: 5,
        top: 8,
        child: DiscuzLink(
          label: '搜索',
          onTap: () {

        FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.onSubmit != null) {
              widget.onSubmit(_controller.text);
            }
          },
        ),
      );
}
