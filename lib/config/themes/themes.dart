import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: primary100,
    scaffoldBackgroundColor: neutral10,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary100,
      onPrimary: neutral10,
      secondary: secondaryPurple100,
      onSecondary: neutral10,
      error: error100,
      onError: neutral10,
      background: neutral20,
      onBackground: neutral90,
      surface: neutral10,
      onSurface: neutral90,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: neutral90),
      bodyMedium: TextStyle(color: neutral80),
      displayLarge: TextStyle(color: neutral100),
      displayMedium: TextStyle(color: neutral100),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primary90,
    scaffoldBackgroundColor: neutral90,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary90,
      onPrimary: neutral10,
      secondary: secondaryPurple90,
      onSecondary: neutral10,
      error: error90,
      onError: neutral10,
      background: neutral80,
      onBackground: neutral10,
      surface: neutral90,
      onSurface: neutral10,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: neutral20),
      bodyMedium: TextStyle(color: neutral30),
      displayLarge: TextStyle(color: neutral10),
      displayMedium: TextStyle(color: neutral10),
    ),
  );
}

// Primary Colors
const Color primary100 = Color(0xFF357EFB);
const Color primary90 = Color(0xFF5291F9);
const Color primary80 = Color(0xFF70A4FA);
const Color primary70 = Color(0xFF8EB7FB);
const Color primary60 = Color(0xFFABC4FC);
const Color primary50 = Color(0xFFC4D9FD);
const Color primary40 = Color(0xFFDCE9FE);
const Color primary30 = Color(0xFFE6F9FE);
const Color primary20 = Color(0xFFF0F6FE);
const Color primary10 = Color(0xFFF5F9FE);

// Secondary Purple Colors
const Color secondaryPurple100 = Color(0xFF7B61FF);
const Color secondaryPurple90 = Color(0xFF9480FF);
const Color secondaryPurple80 = Color(0xFFA999FF);
const Color secondaryPurple70 = Color(0xFFC3B8FF);
const Color secondaryPurple60 = Color(0xFFDBD1FF);
const Color secondaryPurple50 = Color(0xFFE1DBFF);
const Color secondaryPurple40 = Color(0xFFE5E0FF);
const Color secondaryPurple30 = Color(0xFFF2F0FF);
const Color secondaryPurple20 = Color(0xFFF6F5FF);
const Color secondaryPurple10 = Color(0xFFFAFAFF);

// Secondary Green Colors
const Color secondaryGreen100 = Color(0xFF33D68B);
const Color secondaryGreen90 = Color(0xFF51D9C9);
const Color secondaryGreen80 = Color(0xFF77E4B2);
const Color secondaryGreen70 = Color(0xFF91EDC0);
const Color secondaryGreen60 = Color(0xFFAAEECF);
const Color secondaryGreen50 = Color(0xFFBFFDDB);
const Color secondaryGreen40 = Color(0xFFD5F6E7);
const Color secondaryGreen30 = Color(0xFFE2F9EE);
const Color secondaryGreen20 = Color(0xFFEAFBF3);
const Color secondaryGreen10 = Color(0xFFF2FDF8);

// Neutral Colors
const Color neutral100 = Color(0xFF000000);
const Color neutral90 = Color(0xFF2B2B2B);
const Color neutral80 = Color(0xFF454545);
const Color neutral70 = Color(0xFF636363);
const Color neutral60 = Color(0xFF757575);
const Color neutral50 = Color(0xFF8F8F8F);
const Color neutral40 = Color(0xFFA6A6A6);
const Color neutral30 = Color(0xFFE6E6E6);
const Color neutral20 = Color(0xFFF2F2F2);
const Color neutral10 = Color(0xFFFFFFFF);

// Error Colors
const Color error100 = Color(0xFFF06360);
const Color error90 = Color(0xFFF16765);
const Color error80 = Color(0xFFF48281);
const Color error70 = Color(0xFFF69D9C);
const Color error60 = Color(0xFFF8B0B0);
const Color error50 = Color(0xFFFAC2C2);
const Color error40 = Color(0xFFFCDBD9);
const Color error30 = Color(0xFFFDEFE7);
const Color error20 = Color(0xFFFEF1F1);
const Color error10 = Color(0xFFFFFAFA);
