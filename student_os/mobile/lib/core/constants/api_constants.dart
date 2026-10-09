import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  static const String _defaultEmulatorBaseUrl = 'http://10.0.2.2:5000/api';
  static const String _defaultLocalhostBaseUrl = 'http://localhost:5000/api';
  static const String _baseUrlKey = 'custom_api_base_url';

  static String _activeBaseUrl = _defaultEmulatorBaseUrl;

  static String get baseUrl => _activeBaseUrl;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString(_baseUrlKey);
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _activeBaseUrl = savedUrl;
    }
  }

  static Future<void> setBaseUrl(String url) async {
    _activeBaseUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  static Future<void> setCustomBaseUrl(String url) async => setBaseUrl(url);

  static String get defaultEmulatorUrl => _defaultEmulatorBaseUrl;
  static String get defaultLocalhostUrl => _defaultLocalhostBaseUrl;

  // Endpoint routes
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get me => '$baseUrl/auth/me';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';

  static String get dashboard => '$baseUrl/dashboard';
  static String get subjects => '$baseUrl/subjects';
  static String get timetable => '$baseUrl/timetable';
  static String get attendance => '$baseUrl/attendance';
  static String get assignments => '$baseUrl/assignments';
  static String get exams => '$baseUrl/exams';
  static String get notes => '$baseUrl/notes';
  static String get tasks => '$baseUrl/tasks';
  static String get calendar => '$baseUrl/calendar';
  static String get studyPlanner => '$baseUrl/study-planner';
  static String get careerOverview => '$baseUrl/career/overview';
  static String get hackathons => '$baseUrl/career/hackathons';
  static String get internships => '$baseUrl/career/internships';
  static String get jobs => '$baseUrl/career/jobs';
  static String get courses => '$baseUrl/career/courses';
  static String get skills => '$baseUrl/skills';
  static String get resume => '$baseUrl/resume';
  static String get interview => '$baseUrl/interview';
  static String get notifications => '$baseUrl/notifications';
  static String get profile => '$baseUrl/profile';
  static String get aiChat => '$baseUrl/ai/chat';
}
