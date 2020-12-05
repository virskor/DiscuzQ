import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:core/widgets/appbar/appbar.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/utils/StringHelper.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度

  ///
  /// onSubmit(String keyword, bool shouldShowNoticeEmpty)
  /// keyword 用户输入的关键字
  /// shouldShowNoticeEmpty 用户输入的字符为空，是否要提示
  /// 这里为空的是，clear同样会触发onSubmit 这种时候不需要通知用户输入关键字 shouldShowNoticeEmpty== false
  /// 列子 shouldShowNoticeEmpty && keyword == "" 则提示用户输入关键字
  final Function onSubmit;
  final String placeholder;

  SearchAppbar(
      {this.contentHeight = 55, this.placeholder = '输入关键字搜索', this.onSubmit});

  @override
  _SearchAppbarState createState() => _SearchAppbarState();

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class _SearchAppbarState extends State<SearchAppbar> {
  final TextEditingController _controller = TextEditingController();

  /// state
  bool _showButton = false;

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
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            const Positioned(
              child: const AppbarLeading(
                removePreviousPageTitle: true,
              ),
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: 270),

              ///padding: EdgeInsets.only(right: _showButton ? 50 : 0),
              padding: EdgeInsets.only(
                right: _showButton ? 50 : 0,
              ),
              margin: EdgeInsets.only(
                right: 15,
                top: 5,
                  left: ModalRoute.of(context).canPop == true &&
                          ModalRoute.of(context).isFirst == false
                      ? 50
                      : 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
              child: DiscuzTextfiled(
                controller: _controller,
                prefixIcon: const DiscuzIcon(CupertinoIcons.search),
                placeHolder: widget.placeholder,
                borderColor: Colors.transparent,
                bottomMargin: 10,
                borderWidth: 0.1,
                textInputAction: TextInputAction.search,
                clearable: true,
                onClear: () {
                  setState(() {
                    _showButton = false;
                  });

                  if (widget.onSubmit != null) {
                    widget.onSubmit(_controller.text, false);

                    /// 用户清空时，仅触发UI返回到显示历史搜索，但是不提示错误信息

                    /// show notice
                  }
                },
                onChanged: (String val) {
                  ///
                  /// 输入的内容不为空的时候显示按钮，
                  /// 如果已经显示了，就别再buildUI 了
                  if (StringHelper.isEmpty(string: val) ||
                      _showButton == true) {
                    return;
                  }

                  setState(() {
                    _showButton = true;
                  });
                },
                onSubmit: (String val) {
                  if (widget.onSubmit != null) {
                    widget.onSubmit(_controller.text, true);

                    /// show notice
                  }
                },
              ),
            ),

            /// ...搜索按钮
            _showButton ? _searchButton() : const SizedBox()
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
        right: 25,
        top: 13,
        child: Row(
          children: <Widget>[
            DiscuzLink(
              label: '搜索',
              onTap: () {
                setState(() {
                  _showButton = false;
                });
                FocusScope.of(context).requestFocus(FocusNode());
                if (widget.onSubmit != null) {
                  widget.onSubmit(_controller.text, true);

                  /// show notice
                }
              },
            )
          ],
        ),
      );
}
