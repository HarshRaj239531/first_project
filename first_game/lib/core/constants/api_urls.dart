class ApiUrls {
  static const String baseUrl = 'https://api.smarthome-ai.example.com/v1';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh';

  // Devices
  static const String devices = '$baseUrl/devices';
  static String deviceById(String id) => '$baseUrl/devices/$id';
  static String toggleDevice(String id) => '$baseUrl/devices/$id/toggle';

  // Voice
  static const String voiceProcess = '$baseUrl/voice/process';

  // Automation
  static const String automationRules = '$baseUrl/automation/rules';
  static String ruleById(String id) => '$baseUrl/automation/rules/$id';

  // Settings
  static const String userProfile = '$baseUrl/user/profile';
  static const String userSettings = '$baseUrl/user/settings';
}
