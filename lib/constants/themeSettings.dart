// ignore_for_file: file_names

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const _theme = FlexScheme.jungle;
  static final _fontFamily = GoogleFonts.montserrat().fontFamily;

  static final lightTheme = FlexThemeData.light(
    scheme: _theme,
    fontFamily: _fontFamily,
  );

  static final darkTheme = FlexThemeData.dark(
    scheme: _theme,
    fontFamily: _fontFamily,
  );

  static primaryTextButtonStyle(context) {
    return TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor:
          MediaQuery.of(context!).platformBrightness == Brightness.dark
              ? AppThemes.lightTheme.colorScheme.primaryContainer
              : AppThemes.darkTheme.colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  static secondaryTextButtonStyle(context) {
    return TextButton.styleFrom(
      foregroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? AppThemes.lightTheme.colorScheme.primaryContainer
              : AppThemes.darkTheme.colorScheme.primaryContainer,
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? AppThemes.darkTheme.colorScheme.background
              : AppThemes.lightTheme.colorScheme.background,
      side: BorderSide(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? AppThemes.lightTheme.colorScheme.primaryContainer
              : AppThemes.darkTheme.colorScheme.primaryContainer,
          width: 1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  static primaryIconColor(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? AppThemes.lightTheme.colorScheme.primaryContainer
        : AppThemes.darkTheme.colorScheme.primaryContainer;
  }

  static iconColor(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? AppThemes.lightTheme.colorScheme.secondary
        : AppThemes.darkTheme.colorScheme.secondary;
  }
}
