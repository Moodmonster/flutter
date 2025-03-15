import 'package:flutter/material.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';

@immutable
class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    tabBarTheme: TabBarTheme(
      splashFactory: InkRipple.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith((states) => AppColors.secondary)
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary, 
      selectionColor: AppColors.secondary,
      selectionHandleColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.white,
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: AppColors.black)
    ),
  );
}