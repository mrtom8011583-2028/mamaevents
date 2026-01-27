import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _ipApiUrl = 'https://ipapi.co/json/';
  static const String _fallbackApiUrl = 'http://ip-api.com/json';

  static Future<String?> getCountryCode() async {
    try {
      // Try primary API
      final response = await http.get(
        Uri.parse(_ipApiUrl),
        headers: {'User-Agent': 'WasabiCateringApp/1.0'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryCode = data['country_code'] as String?;

        if (countryCode == 'PK') {
          return countryCode;
        }
      }

      // Fallback API
      final fallbackResponse = await http.get(
        Uri.parse(_fallbackApiUrl),
      ).timeout(const Duration(seconds: 3));

      if (fallbackResponse.statusCode == 200) {
        final data = json.decode(fallbackResponse.body);
        final countryCode = data['countryCode'] as String?;

        if (countryCode == 'PK') {
          return countryCode;
        }
      }

      return null; // Unknown location
    } catch (e) {
      print('Location detection error: $e');
      return null;
    }
  }

  static Future<String> detectRegion() async {
    final countryCode = await getCountryCode();

    switch (countryCode) {
      case 'PK':
        return 'pk';
      default:
        return 'global';
    }
  }

  static Map<String, String> getRegionConfig(String region) {
    switch (region) {
      case 'pk':
        return {
          'currency': 'PKR',
          'symbol': 'Rs',
          'phonePrefix': '+92',
          'countryName': 'Pakistan',
          'locale': 'ur_PK',
        };
      default:
        return {
          'currency': 'USD',
          'symbol': '\$',
          'phonePrefix': '+1',
          'countryName': 'Global',
          'locale': 'en_US',
        };
    }
  }
}