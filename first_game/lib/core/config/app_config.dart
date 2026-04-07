class AppConfig {
  /// Toggle this to change between Mock and Real backend
  static const bool useMockBackend = true;

  /// The future API endpoint
  static const String baseUrl = 'https://api.smarthome.ai/v1';

  /// Network timeout settings
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Storage keys
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
}
