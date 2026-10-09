import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized');
    }
    return _prefs!;
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await prefs.setString(AppConstants.authTokenKey, token);
  }

  static String? getToken() {
    return prefs.getString(AppConstants.authTokenKey);
  }

  static Future<void> clearToken() async {
    await prefs.remove(AppConstants.authTokenKey);
  }

  // User management
  static Future<void> saveUser(User user) async {
    await prefs.setString(AppConstants.authUserKey, jsonEncode(user.toJson()));
  }

  static User? getUser() {
    final str = prefs.getString(AppConstants.authUserKey);
    if (str == null) return null;
    try {
      return User.fromJson(jsonDecode(str));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await prefs.remove(AppConstants.authUserKey);
  }

  // Cache for offline mode
  static Future<void> saveCache(String key, dynamic data) async {
    await prefs.setString('${AppConstants.offlineCacheKey}_$key', jsonEncode(data));
  }

  static dynamic getCache(String key) {
    final str = prefs.getString('${AppConstants.offlineCacheKey}_$key');
    if (str == null) return null;
    try {
      return jsonDecode(str);
    } catch (_) {
      return null;
    }
  }

  // Theme mode
  static Future<void> saveThemeMode(String mode) async {
    await prefs.setString(AppConstants.themeModeKey, mode);
  }

  static String getThemeMode() {
    return prefs.getString(AppConstants.themeModeKey) ?? 'system';
  }
}
