import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConstants {
  // Brand Colors
  static const Color gold = Color(0xFFD4AF37);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF121212);
  
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    primaryColor: gold,
    colorScheme: const ColorScheme.light(
      primary: gold,
      secondary: black,
      surface: white,
      background: white,
      onPrimary: black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: black,
      foregroundColor: gold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        color: gold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      iconTheme: const IconThemeData(color: gold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold, // Button background
        foregroundColor: black, // Text color
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: black,
      displayColor: black,
    ),
    // tabBarTheme: const TabBarTheme(
    //   labelColor: gold,
    //   unselectedLabelColor: Colors.grey,
    //   indicatorColor: gold,
    // ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: gold, width: 2),
      ),
    ),
  );
}
