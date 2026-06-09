/// Validators for form fields throughout the Wedding Cards app.
/// All methods return null on success or an error message string on failure.
class Validators {
  Validators._();

  /// Validates an email address format.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password with minimum 6 characters.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates a password confirmation matches the original.
  static String? validateConfirmPassword(String? value, String password) {
    final passwordError = validatePassword(value);
    if (passwordError != null) return passwordError;
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates that a field is not empty.
  static String? validateRequired(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a phone number (supports international formats).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final trimmed = value.trim();
    // Supports formats like +91 9876543210, 9876543210, (091) 987-654-3210
    final phoneRegex = RegExp(
      r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}$',
    );
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates an optional phone number (allows empty).
  static String? validateOptionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return validatePhone(value);
  }

  /// Validates a URL format.
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL (e.g., https://example.com)';
    }
    return null;
  }

  /// Validates an optional URL (allows empty).
  static String? validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return validateUrl(value);
  }

  /// Validates a name field (minimum 2 characters).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Name must be less than 100 characters';
    }
    return null;
  }

  /// Validates a message or description field.
  static String? validateMessage(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Messages are usually optional
    }
    if (value.trim().length > maxLength) {
      return 'Must be less than $maxLength characters';
    }
    return null;
  }

  /// Validates a number of guests (positive integer).
  static String? validateGuestCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Number of guests is required';
    }
    final count = int.tryParse(value.trim());
    if (count == null || count < 1) {
      return 'Please enter a valid number of guests';
    }
    if (count > 10000) {
      return 'Guest count seems too high';
    }
    return null;
  }
}
