import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF4A3D89);
const secondaryColor = Color(0xffbbdefb);

final ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Color(0xFF121212),
  //accentColor: Color(0xFF4CAF50), // Complementing color for light theme (greenish)
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black)),
  buttonTheme: const ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF36618E),
    secondary: Color(0xffbbdefb),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      textStyle: _buildTextStyle(
        color: const Color(0xffe1e2e8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontFamily: 'Circular Std',
        height: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //minimumSize: Size(context.width * 0.8, context.width * 0.15),
    ),
  ),
  textTheme: _buildLightTextTheme(),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 10,
    backgroundColor: Colors.white, // Background color of the nav bar
    selectedItemColor: Colors.black, // Color of the selected icon and label
    unselectedItemColor: Colors.grey, // Color of unselected items
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: 14
    ), // Font size of the selected label
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 12
  ) , // Font size of the unselected label
    type: BottomNavigationBarType
        .fixed, // Set it to fixed to avoid shifting behavior
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      /// Markdown -> Commented BG Color of ICON
      foregroundColor: Colors.white,
      padding: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      //minimumSize: Size(context.width * 0.8, context.width * 0.15),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Color(0xffbbdefb),
  scaffoldBackgroundColor: Color(0xFF121212),
  canvasColor: Colors.white,
  //accentColor: Color(0xFFBB86FC), // Complementing color for dark theme (purple)
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xffbbdefb),
    textTheme: ButtonTextTheme.primary,
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xffbbdefb),
    secondary: Color(0xFF36618E),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xffbbdefb),
      foregroundColor: primaryColor,
      textStyle: _buildTextStyle(
        color: const Color(0xffe1e2e8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontFamily: 'Circular Std',
        height: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //minimumSize: Size(context.width * 0.8, context.width * 0.15),
    ),
  ),
  textTheme: _buildDarkTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    backgroundColor: Color(0xFF121212), // Background color of the nav bar
    selectedItemColor: Colors.white, // Color of the selected icon and label
    unselectedItemColor: Colors.grey, // Color of unselected items
    selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontFamily: "Circular Std"), // Font size of the selected label
    unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontFamily: "Circular Std"), // Font size of the unselected label
    type: BottomNavigationBarType
        .fixed, // Set it to fixed to avoid shifting behavior
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      //minimumSize: Size(context.width * 0.8, context.width * 0.15),
    ),
  ),
);

// Light Text Theme Builder
TextTheme _buildLightTextTheme() {
  return TextTheme(
    bodyLarge: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    bodyMedium: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    bodySmall: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    displayLarge: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      fontFamily: 'Circular Std',
      height: 1.12,
    ),
    displayMedium: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: 'Circular Std',
      height: 1.16,
    ),
    displaySmall: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.22,
    ),
    headlineLarge: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 40,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.25,
    ),
    headlineMedium: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.29,
    ),
    headlineSmall: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelLarge: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    labelMedium: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelSmall: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.75,
      fontFamily: 'Circular Std',
      height: 1.45,
    ),
    titleLarge: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.27,
    ),
    titleMedium: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    titleSmall: _buildTextStyle(
      color: const Color(0xff191c20),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
  );
}

// Light Primary Text Theme Builder
TextTheme _buildLightPrimaryTextTheme() {
  return TextTheme(
    bodyLarge: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    bodyMedium: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    bodySmall: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    displayLarge: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      fontFamily: 'Circular Std',
      height: 1.12,
    ),
    displayMedium: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: 'Circular Std',
      height: 1.16,
    ),
    displaySmall: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.22,
    ),
    headlineLarge: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 40,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.25,
    ),
    headlineMedium: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.29,
    ),
    headlineSmall: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelLarge: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    labelMedium: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelSmall: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.75,
      fontFamily: 'Circular Std',
      height: 1.45,
    ),
    titleLarge: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.27,
    ),
    titleMedium: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    titleSmall: _buildTextStyle(
      color: const Color(0xfff8f9ff),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
  );
}

// Dark Text Theme Builder
TextTheme _buildDarkTextTheme() {
  return TextTheme(
    bodyLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    bodyMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    bodySmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    displayLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      fontFamily: 'Circular Std',
      height: 1.12,
    ),
    displayMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: 'Circular Std',
      height: 1.16,
    ),
    displaySmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.22,
    ),
    headlineLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 40,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.25,
    ),
    headlineMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.29,
    ),
    headlineSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    labelMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Circular Std',
      height: 1.45,
    ),
    titleLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.27,
    ),
    titleMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    titleSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
  );
}

// Dark Primary Text Theme Builder
TextTheme _buildDarkPrimaryTextTheme() {
  return TextTheme(
    bodyLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    bodyMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    bodySmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    displayLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      fontFamily: 'Circular Std',
      height: 1.12,
    ),
    displayMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: 'Circular Std',
      height: 1.16,
    ),
    displaySmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.22,
    ),
    headlineLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 40,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.25,
    ),
    headlineMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Circular Std',
      height: 1.29,
    ),
    headlineSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
    labelMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Circular Std',
      height: 1.33,
    ),
    labelSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: 'Caros',
      height: 1.45,
    ),
    titleLarge: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.27,
    ),
    titleMedium: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: 'Circular Std',
      height: 1.5,
    ),
    titleSmall: _buildTextStyle(
      color: const Color(0xffe1e2e8),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Circular Std',
      height: 1.43,
    ),
  );
}

// Helper function to create TextStyle
TextStyle _buildTextStyle({
  required Color color,
  required double fontSize,
  required FontWeight fontWeight,
  double? letterSpacing,
  String? fontFamily,
  double? height,
}) {
  // return TextStyle(
  //   color: color,
  //   fontSize: fontSize,
  //   fontWeight: fontWeight,
  //   letterSpacing: letterSpacing,
  //   fontFamily: fontFamily,
  //   height: height,
  //   decoration: TextDecoration.none,
  //   decorationColor: color,
  // );

  return GoogleFonts.inter(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
    decoration: TextDecoration.none,
    decorationColor: color,
  );
}
