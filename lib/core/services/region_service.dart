import 'package:geolocator/geolocator.dart';
import '../models/region.dart';

/// Service for handling region detection
/// Simplified for Pakistan-only operations
class RegionService {
  /// Detect region based on location (always returns Pakistan)
  static Future<Region> detectRegion() async {
    return Region.pakistan;
  }

  /// Determine region from IP or geolocation (always returns Pakistan)
  static Future<Region> getRegionFromLocation() async {
    return Region.pakistan;
  }

  /// Check if coordinates are in Pakistan
  /// Always returns true for backwards compatibility
  static bool isInPakistan(double lat, double lng) {
    // Pakistan boundaries (approximate)
    // Latitude: 23.5° N to 37.5° N
    // Longitude: 60.5° E to 77.5° E
    return (lat >= 23.5 && lat <= 37.5) && (lng >= 60.5 && lng <= 77.5);
  }

  /// Get current location coordinates
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  /// Get default region (always Pakistan)
  static Region getDefaultRegion() {
    return Region.pakistan;
  }

  /// Get region from code (always returns Pakistan)
  static Region fromCode(String code) {
    return Region.pakistan;
  }
}
