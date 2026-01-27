import 'package:shared_preferences/shared_preferences.dart';
import '../models/region.dart';

/// Local storage service for persisting user preferences
class StorageService {
  static const String _regionKey = 'selected_region';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _onboardingKey = 'onboarding_completed';

  /// Save selected region
  Future<bool> saveRegion(Region region) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_regionKey, region.code);
    } catch (e) {
      print('Error saving region: $e');
      return false;
    }
  }

  /// Get saved region
  Future<Region?> getSavedRegion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final regionCode = prefs.getString(_regionKey);
      
      if (regionCode != null) {
        return Region.fromCode(regionCode);
      }
      return null;
    } catch (e) {
      print('Error getting saved region: $e');
      return null;
    }
  }

  /// Save theme mode
  Future<bool> saveThemeMode(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_themeKey, themeMode);
    } catch (e) {
      print('Error saving theme mode: $e');
      return false;
    }
  }

  /// Get saved theme mode
  Future<String?> getSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_themeKey);
    } catch (e) {
      print('Error getting theme mode: $e');
      return null;
    }
  }

  /// Mark onboarding as completed
  Future<bool> setOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      print('Error setting onboarding: $e');
      return false;
    }
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      print('Error checking onboarding: $e');
      return false;
    }
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error clearing storage: $e');
      return false;
    }
  }

  /// Save custom key-value pair
  Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print('Error saving string: $e');
      return false;
    }
  }

  /// Get custom string value
  Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print('Error getting string: $e');
      return null;
    }
  }
}
