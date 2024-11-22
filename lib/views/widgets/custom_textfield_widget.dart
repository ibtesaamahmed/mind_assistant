import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_functions.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle hintTextStyle;
  final TextStyle textStyle;
  final Color cursorColor;
  final String hintText;
  final bool readOnly;
  final int? maxLines;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintTextStyle,
    required this.textStyle,
    required this.cursorColor,
    required this.hintText,
    required this.readOnly,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: cursorColor,
      cursorOpacityAnimates: false,
      readOnly: readOnly,
      style: textStyle,
      maxLines: maxLines ?? 1,
      // minLines: 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    );
  }
}

class CustomBorderlessTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle hintTextStyle;
  final TextStyle textStyle;
  final Color cursorColor;
  final String hintText;
  const CustomBorderlessTextField({
    super.key,
    required this.controller,
    required this.hintTextStyle,
    required this.textStyle,
    required this.cursorColor,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: cursorColor,
      cursorOpacityAnimates: false,
      style: textStyle,
      showCursor: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        border: InputBorder.none, // Remove all borders
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}
