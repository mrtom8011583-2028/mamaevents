import 'dart:ui';
import 'region.dart';

/// Application configuration model
/// Manages app-wide settings for Pakistan market
class AppConfig {
  final Region region;
  final String companyName;
  final String companyTagline;
  final String email;
  final String address;
  final Map<String, String> socialMedia;
  final bool maintenanceMode;
  final String version;

  AppConfig({
    this.region = Region.pakistan,
    this.companyName = 'MAMA EVENTS',
    this.companyTagline = 'Premium Catering Services',
    this.email = 'info@freshcatering.com',
    this.address = 'Karachi, Pakistan',
    Map<String, String>? socialMedia,
    this.maintenanceMode = false,
    this.version = '1.0.0',
  }) : socialMedia = socialMedia ?? {};

  /// Get locale for Pakistan
  Locale get locale => const Locale('ur', 'PK');

  /// Factory to create config from data map
  factory AppConfig.fromRegion(Region region, Map<String, dynamic> data) {
    return AppConfig(
      region: Region.pakistan,
      companyName: data['company_name'] as String? ?? 'MAMA EVENTS',
      companyTagline: data['tagline'] as String? ?? 'Premium Catering Services',
      email: data['email'] as String? ?? 'info@freshcatering.com',
      address: data['address'] as String? ?? 'Karachi, Pakistan',
    );
  }

  /// Get phone number (Pakistan number)
  String get phoneNumber {
    return region.whatsappNumber;
  }

  /// Get phone prefix
  String get phonePrefix => region.phonePrefix;

  /// Get country name
  String get countryName => region.countryName;

  /// Get location
  String get location => region.location;

  /// Get WhatsApp number
  String get whatsappNumber => region.whatsappNumber;

  /// Get WhatsApp link
  String getWhatsAppLink({String? message}) {
    return region.getWhatsAppLink(message: message);
  }

  /// Format price in Pakistani Rupees
  String formatPrice(double price) {
    return region.formatPrice(price);
  }

  /// Get currency symbol
  String get currencySymbol => region.currencySymbol;

  /// Get currency code
  String get currency => region.currency;

  /// Get region display name
  String get regionDisplayName => region.displayName;

  /// Get region code
  String get regionCode => region.code;

  /// Create copy with modified fields
  AppConfig copyWith({
    Region? region,
    String? companyName,
    String? companyTagline,
    String? email,
    String? address,
    Map<String, String>? socialMedia,
    bool? maintenanceMode,
    String? version,
  }) {
    return AppConfig(
      region: Region.pakistan,
      companyName: companyName ?? this.companyName,
      companyTagline: companyTagline ?? this.companyTagline,
      email: email ?? this.email,
      address: address ?? this.address,
      socialMedia: socialMedia ?? this.socialMedia,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      version: version ?? this.version,
    );
  }

  /// Default configuration for Pakistan
  factory AppConfig.pakistan() {
    return AppConfig(
      region: Region.pakistan,
      address: 'Karachi, Pakistan',
      socialMedia: {
        'facebook': 'https://facebook.com/freshcatering',
        'instagram': 'https://instagram.com/freshcatering',
        'twitter': 'https://twitter.com/freshcatering',
      },
    );
  }

  /// Create from JSON
  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      region: Region.pakistan,
      companyName: json['companyName'] as String? ?? 'MAMA EVENTS',
      companyTagline: json['companyTagline'] as String? ?? 'Premium Catering Services',
      email: json['email'] as String? ?? 'info@freshcatering.com',
      address: json['address'] as String? ?? 'Karachi, Pakistan',
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      version: json['version'] as String? ?? '1.0.0',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'region': region.code,
      'companyName': companyName,
      'companyTagline': companyTagline,
      'email': email,
      'address': address,
      'socialMedia': socialMedia,
      'maintenanceMode': maintenanceMode,
      'version': version,
    };
  }

  @override
  String toString() {
    return 'AppConfig(region: ${region.name}, company: $companyName)';
  }
}