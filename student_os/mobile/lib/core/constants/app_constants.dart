class AppConstants {
  static const String appName = 'ATTENT-IN';
  static const String appTagline = 'Your entire student life. One OS.';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.attentin.app';
  static const String appLogo = 'assets/images/attent_in_logo.png';

  // Demo Credentials
  static const String demoStudentEmail = 'student@demo.com';
  static const String demoStudentPassword = 'student123';
  static const String demoAdminEmail = 'admin@demo.com';
  static const String demoAdminPassword = 'admin123';

  // Departments
  static const List<String> departments = [
    'AIML',
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'MECH',
    'CIVIL',
  ];

  // College Years
  static const List<int> years = [1, 2, 3, 4];

  // Storage Keys
  static const String authTokenKey = 'auth_jwt_token';
  static const String authUserKey = 'auth_user_data';
  static const String themeModeKey = 'app_theme_mode';
  static const String offlineCacheKey = 'app_offline_cache';
}
