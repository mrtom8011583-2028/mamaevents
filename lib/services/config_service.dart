import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hardcode defaults for Pakistan as requested
  static const String _defaultRegion = 'pk';
  static const String _defaultCurrency = 'PKR';

  static Future<Map<String, dynamic>> fetchRegionData(String region) async {
    // Ignore input region, force Pakistan
    await Future.delayed(const Duration(milliseconds: 100)); // Minimal delay
    return _getPakistanConfig();
  }

  static Map<String, dynamic> _getPakistanConfig() {
    return {
      'welcome_message': 'Welcome to Wasabi Catering - Pakistan',
      'phone_number': '+92 300 1234567',
      'address': 'Lahore, Pakistan',
      'currency': 'PKR',
      'region': 'pk',
    };
  }
}