import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: 'Lato',
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white
      ),
      displaySmall: TextStyle(
        fontSize: 15.sp,
        color: const Color(0xFFB7B7B7),
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 26.sp,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        letterSpacing: -0.5,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF616161),
      ),
    ),

    scaffoldBackgroundColor: const Color(0xFF232323),
    splashColor: const Color(0xFF505050),
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF505050),
        onPrimary: Color(0xFF302F2F),
        secondary: Colors.amber,
        onSecondary: Colors.black,
        error: Color(0xFFE00808),
        onError: Colors.white,
        surface: Color(0xFF272727),
        onSurface: Color(0xFF393939),
        tertiary: Color(0xFF607C08),
        inversePrimary: Color(0xFFE8E8E8)
    ),
  );
}


ThemeData lightTheme() {
  return ThemeData(
    fontFamily: 'Lato',
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87
      ),
      displaySmall: TextStyle(
        fontSize: 15.sp,
        color: const Color(0xFF838383),
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.black87,
        fontSize: 26.sp,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        letterSpacing: -0.5,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF616161),
      ),
    ),

    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    splashColor: const Color(0xFFFFFFFF),
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFEAEAEA),
        onPrimary: Color(0xFFE8E8E8),
        secondary: Colors.amber,
        onSecondary: Color(0xFF000000),
        error: Color(0xFFE00808),
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFFf5f0f0),
        tertiary: Color(0xFF749107),
        inversePrimary: Color(0xFF302F2F)

    ),
  );
}