import 'package:intl/intl.dart';

/// Region model for Pakistan-only catering service
/// Simplified to support Pakistan market exclusively
enum Region {
  pakistan(
    code: 'PK',
    name: 'Pakistan',
    countryName: 'Pakistan',
    currency: 'PKR',
    currencySymbol: 'Rs',
    phonePrefix: '+92',
    location: 'Karachi, Pakistan',
    flag: '🇵🇰',
    whatsappNumber: '+92 305 1340042',
    timezone: 'Asia/Karachi',
    cities: [
      'Wazirabad',
      'Sialkot',
      'Daska',
      'Kamoke',
      'Gujrat',
      'Faisalabad',
      'Lahore',
      'Karachi',
      'Islamabad',
    ],
  );

  const Region({
    required this.code,
    required this.name,
    required this.countryName,
    required this.currency,
    required this.currencySymbol,
    required this.phonePrefix,
    required this.location,
    required this.flag,
    required this.whatsappNumber,
    required this.timezone,
    required this.cities,
  });

  final String code;
  final String name;
  final String countryName;
  final String currency;
  final String currencySymbol;
  final String phonePrefix;
  final String location;
  final String flag;
  final String whatsappNumber;
  final String timezone;
  final List<String> cities;

  /// Format price in Pakistani Rupees
  String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  /// Format phone number with Pakistan prefix
  String formatPhoneNumber(String number) {
    // Remove any existing prefix
    String cleaned = number.replaceAll(RegExp(r'[^\d]'), '');

    // Pakistani format: +92 300 1234567
    if (cleaned.length == 10) {
      return '$phonePrefix ${cleaned.substring(0, 3)} ${cleaned.substring(3)}';
    }

    return '$phonePrefix $cleaned';
  }

  /// Get WhatsApp link with pre-filled message
  String getWhatsAppLink({String? message}) {
    final encodedMessage = Uri.encodeComponent(
      message ?? 'Hi MAMA EVENTS, I would like to inquire about your services.',
    );
    // Remove all spaces, dashes, and special characters except digits
    final cleanNumber = whatsappNumber.replaceAll(RegExp(r'[^\d]'), '');
    return 'https://wa.me/$cleanNumber?text=$encodedMessage';
  }

  /// Get region from code (always returns Pakistan)
  static Region fromCode(String code) {
    return Region.pakistan;
  }

  /// Get display name with flag
  String get displayName => '$flag $name';

  /// Check if region is Pakistan (always true)
  bool get isPakistan => true;
}