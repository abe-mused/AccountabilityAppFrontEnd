import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static var lightTheme = FlexThemeData.light(
    scheme: FlexScheme.mallardGreen,
    fontFamily: GoogleFonts.montserrat().fontFamily,
  );

  static var darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.mallardGreen,
    fontFamily: GoogleFonts.montserrat().fontFamily,
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
}
