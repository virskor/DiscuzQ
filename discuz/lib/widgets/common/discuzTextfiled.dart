import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:discuzq/ui/ui.dart';

class DiscuzTextfiled extends StatelessWidget {
  final Function validator;
  final int maxLines;
  final TextEditingController controller;
  final String placeHolder;
  final EdgeInsetsGeometry contentPadding;
  final bool obscureText;
  final double fontSize;
  final Function onChanged;
  final Function onSubmit;
  final int maxLength;
  final bool autofocus;
  final FocusNode focusNode;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final double borderWidth;
  final bool removeBottomMargin;
  final Color color;
  final Color borderColor;
  final double bottomMargin;

  DiscuzTextfiled(
      {Key key,
      this.maxLines = 1,
      this.placeHolder = '',
      this.controller,
      this.contentPadding,
      this.fontSize,
      this.autofocus = false,
      this.onChanged,
      this.focusNode,
      this.bottomMargin = 10,
      this.color,
      this.onSubmit,
      this.removeBottomMargin = false,
      this.maxLength = 60,
      this.borderWidth = 2,
      this.borderColor,
      this.inputType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
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
            onChanged: onChanged,
            onFieldSubmitted: onSubmit,
            maxLength: maxLength,
            enableSuggestions: false,
            decoration: InputDecoration(
                hintText: placeHolder,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize:
                      fontSize ?? DiscuzApp.themeOf(context).mediumTextSize,
                ),
                contentPadding: contentPadding == null
                    ? const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10)
                    : contentPadding,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.34), width: borderWidth),
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
                fontSize: fontSize ?? DiscuzApp.themeOf(context).mediumTextSize,
                color: DiscuzApp.themeOf(context).textColor),
          ),
        ),
      );
}
