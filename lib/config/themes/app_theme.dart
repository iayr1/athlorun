import 'package:flutter/material.dart';

/// Design tokens from the asklepios UI Kit (Figma).
///
/// Names follow the kit: "Therapeia Blue", "Asklepios Gray", "Hygieia Red",
/// "Aceso Purple". Legacy aliases (primary, ink, …) are kept so every screen
/// picks up the kit colours.
class AppPalette {
  // Therapeia Blue
  static const Color blue60 = Color(0xFF0F67FE);
  static const Color blue20 = Color(0xFFD0E4FF);
  static const Color blue10 = Color(0xFFEDF5FF);

  // Asklepios Gray
  static const Color gray80 = Color(0xFF242E49);
  static const Color gray60 = Color(0xFF5D6A85);
  static const Color gray50 = Color(0xFF818BA0);
  static const Color gray40 = Color(0xFF9EA7B8);
  static const Color gray30 = Color(0xFFBEC5D2);
  static const Color gray20 = Color(0xFFDCE1E8);
  static const Color gray10 = Color(0xFFF2F5F9);

  // Hygieia Red
  static const Color red50 = Color(0xFFFA4D5E);
  static const Color red10 = Color(0xFFFFF1F3);

  // Aceso Purple
  static const Color purple60 = Color(0xFF8A3FFC);
  static const Color purple20 = Color(0xFFE6DAFF);

  // Semantic aliases used across the app.
  static const Color primary = blue60;
  static const Color primaryDark = Color(0xFF0A4FC4);
  static const Color blue = blue60;
  static const Color cyan = Color(0xFF08B4BD);
  static const Color orange = Color(0xFFFF8A34);
  static const Color pink = Color(0xFFEC4899);
  static const Color green = Color(0xFF22C55E);
  static const Color purple = purple60;
  static const Color amber = Color(0xFFF9BC1E);
  static const Color red = red50;

  static const Color ink = gray80;
  static const Color inkSoft = gray60;
  static const Color muted = gray40;
  static const Color line = gray20;
  static const Color background = gray10;
  static const Color surface = Colors.white;

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F67FE), Color(0xFF3D86FF)],
  );

  static const LinearGradient night = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gray80, Color(0xFF34405F)],
  );

  static const LinearGradient fire = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [red50, Color(0xFFFF7A86)],
  );

  static const LinearGradient fresh = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF08B4BD), Color(0xFF3DD6DD)],
  );

  static const LinearGradient dream = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple60, Color(0xFFA56BFF)],
  );

  /// "Card Shadow Black 5%" effect from the kit.
  static List<BoxShadow> softShadow([Color color = const Color(0xFF090E1D)]) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.05),
        blurRadius: 32,
        offset: const Offset(0, 16),
      ),
    ];
  }

  /// "Focus/ring" effect: 4px spread ring at 25% opacity.
  static List<BoxShadow> focusRing(Color color) => [
        BoxShadow(color: color.withValues(alpha: 0.25), spreadRadius: 4),
      ];
}

/// Text styles from the kit (Plus Jakarta Sans, -1% tracking).
class AppText {
  static const String family = 'PlusJakartaSans';

  static TextStyle _s(double size, FontWeight weight, {double? height}) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: -0.01 * size,
        color: AppPalette.ink,
      );

  /// Heading sm/ExtraBold — 30/38.
  static final TextStyle headingSm = _s(30, FontWeight.w800, height: 38 / 30);
  static final TextStyle headingXs = _s(24, FontWeight.w800, height: 32 / 24);
  static final TextStyle textXlExtraBold = _s(20, FontWeight.w800);
  static final TextStyle textMdExtraBold = _s(16, FontWeight.w800);
  static final TextStyle textMdBold = _s(16, FontWeight.w700);
  static final TextStyle textMdSemiBold = _s(16, FontWeight.w600);
  static final TextStyle textSmExtraBold = _s(14, FontWeight.w800);
  static final TextStyle textSmSemiBold = _s(14, FontWeight.w600);

  /// Paragraph/md — Medium 16, 160% line height.
  static const TextStyle paragraphMd = TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppPalette.gray60,
  );

  /// Paragraph/sm — Medium 14, 160% line height.
  static const TextStyle paragraphSm = TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppPalette.gray60,
  );

  /// Label/xs — ExtraBold 10, 10% tracking, uppercase.
  static const TextStyle labelXs = TextStyle(
    fontFamily: family,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
    color: AppPalette.gray60,
  );
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      primary: AppPalette.primary,
      secondary: AppPalette.cyan,
      surface: AppPalette.surface,
      error: AppPalette.red,
      brightness: Brightness.light,
    );

    final base = ThemeData(
      useMaterial3: true,
      fontFamily: AppText.family,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.background,
    );

    final text = base.textTheme.apply(
      fontFamily: AppText.family,
      bodyColor: AppPalette.ink,
      displayColor: AppPalette.ink,
    );

    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppPalette.ink,
        titleTextStyle: TextStyle(
          fontFamily: AppText.family,
          color: AppPalette.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppPalette.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppPalette.blue10,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? AppPalette.primary : AppPalette.gray40,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppPalette.primary : AppPalette.gray40,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.primary,
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppText.textMdBold,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.ink,
          minimumSize: const Size(0, 56),
          side: const BorderSide(color: AppPalette.gray40),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppText.textMdBold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.primary,
          textStyle: AppText.textSmExtraBold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppPalette.ink,
        contentTextStyle: const TextStyle(
          fontFamily: AppText.family,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 6,
        activeTrackColor: AppPalette.primary,
        thumbColor: AppPalette.primary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppPalette.primary,
        linearTrackColor: AppPalette.gray20,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
