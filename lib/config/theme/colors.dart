import 'package:flutter/material.dart';

/// MAMA EVENTS Premium Color Palette
/// Derived from interlocking "M" logo analysis
/// Senior Flutter Architect specification
class AppColors {
  // ═══════════════════════════════════════════════════════════════
  // PRIMARY BRAND COLORS (Source of Truth)
  // ═══════════════════════════════════════════════════════════════
  static const Color logoDeepBlack = Color(0xFF121212);      // Main Backgrounds / Primary Text
  static const Color logoCharcoalGrey = Color(0xFF2C2C2C);   // Card Backgrounds / Secondary Text
  static const Color softWhite = Color(0xFFF0F0F0);          // Page Backgrounds / Light Accents
  static const Color pureWhite = Color(0xFFFFFFFF);          // Card Surfaces
  
  // Backward compatibility alias
  static const Color logoSilverWhite = softWhite;

  // ═══════════════════════════════════════════════════════════════
  // LUXURY GOLD SYSTEM (Gradients & Accents)
  // ═══════════════════════════════════════════════════════════════
  static const Color goldGradientStart = Color(0xFFD4AF37);  // MAMA Gold
  static const Color goldGradientEnd = Color(0xFFB8860B);    // Antique Gold / Bronze
  static const Color premiumGoldLight = Color(0xFFD4AF37);   // Highlights
  static const Color premiumGoldMedium = Color(0xFFD4AF37);  // Main Gold (Source of Truth)
  static const Color premiumGoldDark = Color(0xFF997515);    // Shadows
  static const Color primaryGold = premiumGoldMedium;        // Alias for primary gold usage

  static const Gradient premiumGoldGradient = LinearGradient(
    colors: [goldGradientStart, premiumGoldMedium, goldGradientEnd],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );

  static const Gradient goldHoverGradient = LinearGradient(
    colors: [premiumGoldMedium, goldGradientStart, premiumGoldMedium],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [logoDeepBlack, logoCharcoalGrey],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFF000000), logoDeepBlack, logoCharcoalGrey],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ═══════════════════════════════════════════════════════════════
  // NEUTRAL SYSTEM
  // ═══════════════════════════════════════════════════════════════
  static const Color lightGrey = Color(0xFFE0E0E0);          // Dividers
  static const Color mediumGrey = Color(0xFF888888);         // Subtitles
  static const Color darkGrey = Color(0xFF4A4A4A);           // Body Text
  static const Color whatsappGreen = Color(0xFF25D366);      // WhatsApp
  static const Color error = Color(0xFFD32F2F);              // Error Red
  static const Color success = Color(0xFF388E3C);            // Success Green

  // ═══════════════════════════════════════════════════════════════
  // LEGACY COMPATIBILITY (Map to new palette)
  // ═══════════════════════════════════════════════════════════════
  static const Color primaryBlack = logoDeepBlack;
  static const Color primaryDark = logoDeepBlack;
  static const Color primaryGrey = logoCharcoalGrey;
  static const Color primaryLightGrey = softWhite;
  static const Color primaryWhite = pureWhite;
  static const Color accent = premiumGoldMedium;
  static const Color accentLight = premiumGoldLight;
  
  static const Color freshGreen = logoDeepBlack;
  static const Color freshOrange = premiumGoldMedium;
  static const Color darkText = logoDeepBlack;
  static const Color bodyText = darkGrey;
  static const Color white = pureWhite;

  // ═══════════════════════════════════════════════════════════════
  // CATERING TIER COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color tier1Silver = Color(0xFFC0C0C0);
  static const Color tier2Bronze = Color(0xFFCD7F32);
  static const Color tier3Gold = Color(0xFFD4AF37);
  static const Color tier4Platinum = Color(0xFFE5E4E2);
  static const Color tier5Diamond = Color(0xFFB9F2FF);

  static const Gradient tier1Gradient = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFFB0B0B0), Color(0xFFE0E0E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tier2Gradient = LinearGradient(
    colors: [Color(0xFFFFD180), Color(0xFFA1887F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tier3Gradient = premiumGoldGradient;

  static const Gradient tier4Gradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0), Color(0xFF9E9E9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tier5Gradient = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF4DD0E1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getTierColor(int tier) {
    switch (tier) {
      case 1: return tier1Silver;
      case 2: return tier2Bronze;
      case 3: return tier3Gold;
      case 4: return tier4Platinum;
      case 5: return tier5Diamond;
      default: return tier1Silver;
    }
  }

  static Gradient getTierGradient(int tier) {
    switch (tier) {
      case 1: return tier1Gradient;
      case 2: return tier2Gradient;
      case 3: return tier3Gradient;
      case 4: return tier4Gradient;
      case 5: return tier5Gradient;
      default: return tier1Gradient;
    }
  }

  static String getTierName(int tier) {
    switch (tier) {
      case 1: return 'The Essential Collection';
      case 2: return 'Heritage Classic';
      case 3: return 'Signature Selection';
      case 4: return 'Grand Banquet';
      case 5: return 'Sovereign Experience';
      default: return 'The Essential Collection';
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SERVICE CATEGORY COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color corporateBlue = Color(0xFF2C5282);        // Corporate & Contract
  static const Color weddingGold = Color(0xFFD4AF37);          // Wedding & Private (Premium Gold)
  static const Color liveStationOrange = Color(0xFFED8936);    // Live Interactive Stations
  static const Color infrastructureCharcoal = Color(0xFF4A5568); // Event Infrastructure
  static const Color yachtNavy = Color(0xFF2D3748);            // Yacht Catering
  static const Color partyPurple = Color(0xFF805AD5);          // Private Parties

  // Service Icon Backgrounds
  static const Gradient corporateGradient = LinearGradient(
    colors: [Color(0xFF4299E1), corporateBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient weddingGradient = LinearGradient(
    colors: [premiumGoldLight, weddingGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient liveGradient = LinearGradient(
    colors: [Color(0xFFF6AD55), liveStationOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient infrastructureGradient = LinearGradient(
    colors: [Color(0xFF718096), infrastructureCharcoal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static get luxuryBlack => null;

  // Helper method to get gradient by service type
  static Gradient getServiceGradient(String type) {
    switch (type) {
      case 'Corporate': return corporateGradient;
      case 'Wedding': return weddingGradient;
      case 'Live Stations': return liveGradient;
      case 'Infrastructure': return infrastructureGradient;
      default: return premiumGoldGradient;
    }
  }
}