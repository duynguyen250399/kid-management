import 'package:flutter/material.dart';
import 'package:kid_management/src/theme/icon_theme.dart';

ThemeData appThemeData() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: iconThemeData
    ),
    fontFamily: 'Open_Sans'
  );
}
