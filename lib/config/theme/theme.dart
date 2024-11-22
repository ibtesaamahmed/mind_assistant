import 'package:flutter/material.dart';
import 'package:mind_assistant/constants/app_colors.dart';
import 'package:mind_assistant/constants/app_fonts.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kDSecondryColor,
  fontFamily: AppFonts.Inter,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kWhiteColor,
  ),
  splashColor: kPrimaryColor.withOpacity(0.10),
  highlightColor: kPrimaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.1),
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: kBlackColor.withOpacity(0.8),
  fontFamily: AppFonts.Inter,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kDPrimaryColor,
  ),
  splashColor: kPrimaryColor.withOpacity(0.10),
  highlightColor: kPrimaryColor.withOpacity(0.10),
  // colorScheme: ColorScheme.dark(
  //   primary: kSecondaryColor,
  //   secondary: kSecondaryColor.withOpacity(0.5),
  //   outline: kSecondaryColor.withOpacity(0.1),
  // ),
  // textSelectionTheme: const TextSelectionThemeData(
  //   cursorColor: kBlackColor,
  // ),
);
