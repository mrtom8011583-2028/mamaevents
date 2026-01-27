// 📍 MAMA EVENTS - Office Locations Data
// Regional office information for Pakistan

class OfficeLocation {
  final String id;
  final String regionCode; // 'PK'
  final String cityName;
  final String officeName;
  final String addressLine1;
  final String addressLine2;
  final String? addressLine3;
  final String phone;
  final String whatsapp;
  final String email;
  final Map<String, String> businessHours; // e.g., {'Mon-Fri': '9:00 AM - 6:00 PM'}
  final double? latitude;
  final double? longitude;
  final bool isHeadOffice;

  OfficeLocation({
    required this.id,
    required this.regionCode,
    required this.cityName,
    required this.officeName,
    required this.addressLine1,
    required this.addressLine2,
    this.addressLine3,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.businessHours,
    this.latitude,
    this.longitude,
    this.isHeadOffice = false,
  });

  String get fullAddress {
    final parts = [addressLine1, addressLine2, if (addressLine3 != null) addressLine3!];
    return parts.join(', ');
  }
}

class OfficeLocationsData {
  static final List<OfficeLocation> allOffices = [
    // =============================================================================
    // 🇵🇰 PAKISTAN OFFICES
    // =============================================================================
    OfficeLocation(
      id: 'pk_lahore_head',
      regionCode: 'PK',
      cityName: 'Lahore',
      officeName: 'MAMA EVENTS - Pakistan Head Office',
      addressLine1: 'Plot 123, Main Boulevard',
      addressLine2: 'DHA Phase 6, Lahore',
      addressLine3: 'Punjab, Pakistan',
      phone: '+92 305 1340042',
      whatsapp: '+92 305 1340042',
      email: 'lahore@freshcatering.pk',
      businessHours: {
        'Monday - Friday': '9:00 AM - 7:00 PM',
        'Saturday': '10:00 AM - 5:00 PM',
        'Sunday': 'Closed',
      },
      latitude: 31.4697,
      longitude: 74.2728,
      isHeadOffice: true,
    ),
    OfficeLocation(
      id: 'pk_karachi',
      regionCode: 'PK',
      cityName: 'Karachi',
      officeName: 'MAMA EVENTS - Karachi Branch',
      addressLine1: 'Office No. 45, 2nd Floor',
      addressLine2: 'Clifton Block 5, Karachi',
      addressLine3: 'Sindh, Pakistan',
      phone: '+92 321 2345678',
      whatsapp: '+92 321 2345678',
      email: 'karachi@freshcatering.pk',
      businessHours: {
        'Monday - Friday': '9:00 AM - 7:00 PM',
        'Saturday': '10:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
      latitude: 24.8170,
      longitude: 67.0497,
      isHeadOffice: false,
    ),
    OfficeLocation(
      id: 'pk_islamabad',
      regionCode: 'PK',
      cityName: 'Islamabad',
      officeName: 'MAMA EVENTS - Islamabad Branch',
      addressLine1: 'Street 12, F-7 Markaz',
      addressLine2: 'Islamabad',
      addressLine3: 'Capital Territory, Pakistan',
      phone: '+92 333 4567890',
      whatsapp: '+92 333 4567890',
      email: 'islamabad@freshcatering.pk',
      businessHours: {
        'Monday - Friday': '9:00 AM - 6:00 PM',
        'Saturday': '10:00 AM - 3:00 PM',
        'Sunday': 'Closed',
      },
      latitude: 33.7077,
      longitude: 73.0469,
      isHeadOffice: false,
    ),

  ];

  // =============================================================================
  // 📋 HELPER METHODS
  // =============================================================================

  /// Get offices by region code
  static List<OfficeLocation> getOfficesByRegion(String regionCode) {
    return allOffices.where((office) => office.regionCode == regionCode).toList();
  }

  /// Get head office for region
  static OfficeLocation? getHeadOffice(String regionCode) {
    try {
      return allOffices.firstWhere(
        (office) => office.regionCode == regionCode && office.isHeadOffice,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get office by ID
  static OfficeLocation? getOfficeById(String id) {
    try {
      return allOffices.firstWhere((office) => office.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all cities for a region
  static List<String> getCitiesByRegion(String regionCode) {
    return allOffices
        .where((office) => office.regionCode == regionCode)
        .map((office) => office.cityName)
        .toSet()
        .toList();
  }
}
