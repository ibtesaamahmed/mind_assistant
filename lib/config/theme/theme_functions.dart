import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_assistant/config/theme/theme_controller.dart';
import 'package:mind_assistant/constants/app_colors.dart';

// bool isDark = themeController.isDarkTheme.value;
// bool isDark = themeController.isDarkTheme.value = false;

ThemeController themeController = Get.find<ThemeController>();

Color getbkColor() {
  return themeController.isDarkTheme.value ? kDPrimaryColor : kPrimaryColor;
}

Color getTitleFontColor() {
  return themeController.isDarkTheme.value ? kWhiteColor : kBlackColor;
}

Color getAppBarBackgroundColor() {
  return themeController.isDarkTheme.value ? kDPrimaryColor : kWhiteColor;
}

Color getTileColor() {
  return themeController.isDarkTheme.value ? kDPrimaryColor : kWhiteColor;
}

Color getSubTileColor() {
  return themeController.isDarkTheme.value ? kWhiteColor : kGreyColor;
}
