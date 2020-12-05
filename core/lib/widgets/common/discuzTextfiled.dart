import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:core/utils/debouncer.dart';

class DiscuzTextfiled extends StatelessWidget {
  ///
  /// 提交时校验的函数
  final Function validator;

  ///
  /// 允许最大的行数
  final int maxLines;

  ///
  /// TextEditingController 绑定
  final TextEditingController controller;

  ///
  /// placeholder 类似hintText
  final String placeHolder;

  ///
  /// 内容区缩进
  final EdgeInsetsGeometry contentPadding;

  ///
  /// 是否混淆输入的字符
  /// 输入密码时设置为true
  final bool obscureText;

  ///
  /// 字号
  final double fontSize;

  ///
  /// 输入内容变化的 callback
  /// (String val) => null
  final Function onChanged;

  ///
  /// 用户提交
  final Function onSubmit;

  ///
  /// 允许最大的长度
  final int maxLength;

  ///
  /// 自动聚焦
  final bool autofocus;

  ///
  /// 聚焦
  final FocusNode focusNode;

  ///
  /// 输入类型
  final TextInputType inputType;

  ///
  /// 输入行为
  final TextInputAction textInputAction;

  ///
  /// 变宽
  ///
  final double borderWidth;

  ///
  /// 移除底部缩进
  ///
  final bool removeBottomMargin;

  ///
  /// 颜色
  ///
  final Color color;

  ///
  /// 变色
  ///
  final Color borderColor;

  ///
  /// 底部缩进
  final double bottomMargin;

  ///
  /// 是否允许清空
  /// 默认false
  ///
  final bool clearable;

  ///
  /// prefix icon
  /// 默认不显示
  ///
  final DiscuzIcon prefixIcon;

  ///
  /// 被清除 callback
  ///
  final Function onClear;

  ///
  /// 自动更正
  /// 默认 false
  final bool autocorrect;

  final Debouncer _debouncer = Debouncer(milliseconds: 400);

  DiscuzTextfiled(
      {Key key,
      this.maxLines = 1,
      this.placeHolder = '',
      this.controller,
      this.contentPadding,
      this.fontSize,
      this.autofocus = false,
      this.autocorrect = false,
      this.onChanged,
      this.focusNode,
      this.bottomMargin = 10,
      this.prefixIcon,
      this.color,
      this.onSubmit,
      this.removeBottomMargin = false,
      this.maxLength = 60,
      this.borderWidth = 2,
      this.borderColor,
      this.clearable = false,
      this.inputType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
      this.onClear,
      this.validator});

  @override
  Widget build(BuildContext context) => Container(
        margin: removeBottomMargin == true
            ? null
            : EdgeInsets.only(bottom: bottomMargin),
        decoration: BoxDecoration(color: color),
        child: Theme(
          data: ThemeData(
              textTheme: TextTheme(
                  subtitle1: TextStyle(textBaseline: TextBaseline.alphabetic))),
          child: TextFormField(
            controller: controller,
            validator: validator,
            autofocus: autofocus,
            focusNode: focusNode,
            keyboardAppearance: Brightness.dark,
            textInputAction: textInputAction,
            keyboardType: inputType,
            obscureText: obscureText,
            maxLines: maxLines,
            onChanged: (val) {
              if(onChanged == null){
                return;
              }
              _debouncer.run(() {
                onChanged(val);
              });
            },
            onFieldSubmitted: onSubmit,
            maxLength: maxLength,
            showCursor: true,
            enableSuggestions: false,
            autocorrect: autocorrect,
            decoration: InputDecoration(
                prefixIcon: prefixIcon == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: prefixIcon,
                      ),

                /// 显示清除按钮
                suffixIcon:
                    clearable == false ? null : _clearable(context: context),
                hintText: placeHolder,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize:
                      fontSize ?? DiscuzApp.themeOf(context).normalTextSize,
                ),
                contentPadding: contentPadding == null
                    ? const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10)
                    : contentPadding,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(
                      color: borderColor ?? Theme.of(context).primaryColor,
                      width: borderWidth),
                ),
                counterText: "",
                border: InputBorder.none,
                errorBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                        width: borderWidth)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(
                        color: borderColor ?? Theme.of(context).primaryColor,
                        width: borderWidth))),
            style: TextStyle(
                fontSize: fontSize ?? DiscuzApp.themeOf(context).normalTextSize,
                color: DiscuzApp.themeOf(context).textColor),
          ),
        ),
      );

  ///
  /// 清除按钮
  ///
  Widget _clearable({BuildContext context}) => Container(
      margin: const EdgeInsets.only(top: 8),
      child: Center(
        widthFactor: 1,
        child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: DiscuzIcon(
              Icons.clear,
              size: 20,
              color: DiscuzApp.themeOf(context).greyTextColor,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              controller.clear();
              if (onClear != null) {
                onClear();
              }
            }),
      ));
}
