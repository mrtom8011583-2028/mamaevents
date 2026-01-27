/// Form validators utility class
class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Phone number validation
  static String? validatePhone(String? value, {String? regionCode}) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (regionCode == 'PK') {
      // Pakistani phone: 10 digits
      if (cleaned.length != 10) {
        return 'Please enter a valid Pakistani phone number';
      }
    } else {
      // Generic validation
      if (cleaned.length < 9 || cleaned.length > 15) {
        return 'Please enter a valid phone number';
      }
    }
    
    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Number validation
  static String? validateNumber(String? value, {int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    final number = int.tryParse(value);
    
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return 'Minimum value is $min';
    }
    
    if (max != null && number > max) {
      return 'Maximum value is $max';
    }
    
    return null;
  }

  /// Guests validation
  static String? validateGuests(String? value) {
    return validateNumber(value, min: 1, max: 10000);
  }

  /// Message/Notes validation
  static String? validateMessage(String? value, {int minLength = 10}) {
    if (value == null || value.isEmpty) {
      return 'Message is required';
    }
    
    if (value.trim().length < minLength) {
      return 'Message must be at least $minLength characters';
    }
    
    return null;
  }
}
