import 'package:flutter/material.dart';

import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

///自定义Dialog
class DiscuzDialog extends StatefulWidget {
  //------------------不带图片的dialog------------------------
  final String title; //弹窗标题
  final String message; //弹窗内容
  final String confirmContent; //按钮文本
  final Color confirmTextColor; //确定按钮文本颜色
  final bool isCancel; //是否有取消按钮，默认为true true：有 false：没有
  final Color confirmColor; //确定按钮颜色
  final Color cancelColor; //取消按钮颜色
  final bool outsideDismiss; //点击弹窗外部，关闭弹窗，默认为true true：可以关闭 false：不可以关闭
  final Function onConfirm; //点击确定按钮回调
  final Function onDismiss; //弹窗关闭回调

  //------------------带图片的dialog------------------------
  final String image; //dialog添加图片
  final String imageHintText; //图片下方的文本提示

  const DiscuzDialog(
      {Key key,
      this.title,
      this.message,
      this.confirmContent,
      this.confirmTextColor,
      this.isCancel = false,
      this.confirmColor,
      this.cancelColor,
      this.outsideDismiss = true,
      this.onConfirm,
      this.onDismiss,
      this.image,
      this.imageHintText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DiscuzDialogState();
  }
}

class _DiscuzDialogState extends State<DiscuzDialog> {
  _confirmDialog() {
    _dismissDialog();
    if (widget.onConfirm != null) {
      widget.onConfirm();
    }
  }

  _dismissDialog() {
    if (widget.onDismiss != null) {
      widget.onDismiss();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    Column _columnText = Column(
      children: <Widget>[
        SizedBox(height: widget.title == null ? 0 : 16.0),
        DiscuzText(
          widget.title == null ? '' : widget.title,
          fontSize: DiscuzApp.themeOf(context).mediumTextSize,
        ),
        Expanded(
            child: Center(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right:10),
                    child: DiscuzText(
                widget.message == null ? '' : widget.message,
                color: DiscuzApp.themeOf(context).greyTextColor,
                
              ),)),
            ),
            flex: 1),
        const DiscuzDivider(padding: 0,),
        Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: widget.isCancel
                        ? Container(
                            decoration: BoxDecoration(
                                color: widget.cancelColor == null
                                    ? DiscuzApp.themeOf(context)
                                        .backgroundColor
                                    : widget.cancelColor,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: const Radius.circular(12.0))),
                            child: FlatButton(
                              child: DiscuzText(
                                '取消',
                                color: widget.cancelColor == null
                                    ? DiscuzApp.themeOf(context).textColor
                                    : widget.cancelColor,
                              ),
                              onPressed: _dismissDialog,
                              splashColor: widget.cancelColor == null
                                  ? DiscuzApp.themeOf(context)
                                      .backgroundColor
                                  : widget.cancelColor,
                              highlightColor: widget.cancelColor == null
                                  ? DiscuzApp.themeOf(context)
                                      .backgroundColor
                                  : widget.cancelColor,
                            ),
                          )
                        : const Text(''),
                    flex: widget.isCancel ? 1 : 0),
                SizedBox(
                    width: widget.isCancel ? .56 : 0,
                    child: Container(color: const Color(0x1F000000), width: .56,)),
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.confirmColor == null
                              ? DiscuzApp.themeOf(context).backgroundColor
                              : widget.confirmColor,
                          borderRadius: widget.isCancel
                              ? const BorderRadius.only(
                                  bottomRight: Radius.circular(12.0))
                              : const BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0))),
                      child: FlatButton(
                        onPressed: _confirmDialog,
                        child: DiscuzText(
                          widget.confirmContent == null
                              ? '确定'
                              : widget.confirmContent,
                          color: widget.confirmColor == null
                              ? (widget.confirmTextColor == null
                                  ? DiscuzApp.themeOf(context).primaryColor
                                  : widget.confirmTextColor)
                              : DiscuzApp.themeOf(context).backgroundColor,
                        ),
                        splashColor: widget.confirmColor == null
                            ? DiscuzApp.themeOf(context).backgroundColor
                            : widget.confirmColor,
                        highlightColor: widget.confirmColor == null
                            ? DiscuzApp.themeOf(context).backgroundColor
                            : widget.confirmColor,
                      ),
                    ),
                    flex: 1),
              ],
            ))
      ],
    );

    Column _columnImage = Column(
      children: <Widget>[
        SizedBox(
          height: widget.imageHintText == null ? 35.0 : 23.0,
        ),
        Image(
            image: AssetImage(widget.image == null ? '' : widget.image),
            width: 72.0,
            height: 72.0),
        const SizedBox(height: 10.0),
        Text(widget.imageHintText == null ? "" : widget.imageHintText,
            style: const TextStyle(fontSize: 16.0)),
      ],
    );

    return WillPopScope(
        child: GestureDetector(
          onTap: () => {widget.outsideDismiss ? _dismissDialog() : null},
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                width: widget.image == null ? width - 100.0 : width - 150.0,
                height: 190.0,
                alignment: Alignment.center,
                child: widget.image == null ? _columnText : _columnImage,
                decoration: BoxDecoration(
                    color: DiscuzApp.themeOf(context).backgroundColor,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return widget.outsideDismiss;
        });
  }
}
