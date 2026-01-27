import 'package:flutter/material.dart';
import '../core/models/app_config.dart';
import '../core/models/region.dart';
import '../services/config_service.dart';

/// App configuration provider for Pakistan market
/// Simplified to support Pakistan only
class AppConfigProvider extends ChangeNotifier {
  // Start with default Pakistan config
  AppConfig _config = AppConfig.pakistan();
  bool _isLoading = false;
  String? _error;

  AppConfig get config => _config;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize configuration
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch Pakistan region data
      Map<String, dynamic> regionData = {};
      try {
        regionData = await ConfigService.fetchRegionData('pk').timeout(
          const Duration(seconds: 3),
          onTimeout: () => {},
        );
      } catch (e) {
        debugPrint('Config fetch error (using defaults): $e');
      }

      _config = AppConfig.fromRegion(Region.pakistan, regionData);
      _error = null;
    } catch (e) {
      debugPrint('Configuration error: $e');
      _config = AppConfig.pakistan();
      _error = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set region (always Pakistan)
  void setRegion(Region region) {
    debugPrint('🔄 AppConfigProvider.setRegion called with: ${region.name}');
    _config = AppConfig.pakistan();
    debugPrint('✅ AppConfig updated - WhatsApp: ${_config.whatsappNumber}');
    notifyListeners();

    // Try to fetch remote config in background
    _fetchRemoteConfig();
  }

  /// Fetch remote configuration
  Future<void> _fetchRemoteConfig() async {
    try {
      final regionData = await ConfigService.fetchRegionData('pk');
      _config = AppConfig.fromRegion(Region.pakistan, regionData);
      notifyListeners();
    } catch (e) {
      debugPrint('Config fetch error: $e');
      // Keep using the default config
    }
  }

  /// Get locale for Pakistan
  Locale get locale => _config.locale;
}