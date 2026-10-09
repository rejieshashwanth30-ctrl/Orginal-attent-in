import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final bool isFromCache;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.isFromCache = false,
  });
}

class ApiService {
  static Map<String, String> _getHeaders({bool requiresAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request with offline cache fallback
  static Future<ApiResponse<dynamic>> get(
    String url, {
    bool requiresAuth = true,
    String? cacheKey,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _getHeaders(requiresAuth: requiresAuth))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'] ?? decoded;
        if (cacheKey != null) {
          await StorageService.saveCache(cacheKey, data);
        }
        return ApiResponse(success: true, data: data);
      } else {
        final decoded = _tryDecode(response.body);
        return ApiResponse(
          success: false,
          message: decoded?['message'] ?? 'Request failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      // Offline fallback: load cached data if available
      if (cacheKey != null) {
        final cached = StorageService.getCache(cacheKey);
        if (cached != null) {
          return ApiResponse(
            success: true,
            data: cached,
            isFromCache: true,
            message: 'Loaded from offline cache',
          );
        }
      }
      return ApiResponse(
        success: false,
        message: 'Network connection issue: ${_getReadableError(e)}',
      );
    }
  }

  // POST request
  static Future<ApiResponse<dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: decoded?['data'] ?? decoded,
          message: decoded?['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: decoded?['message'] ?? 'Error with status ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network connection issue: ${_getReadableError(e)}',
      );
    }
  }

  // PUT request
  static Future<ApiResponse<dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: decoded?['data'] ?? decoded,
          message: decoded?['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: decoded?['message'] ?? 'Error with status ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network connection issue: ${_getReadableError(e)}',
      );
    }
  }

  // PATCH request
  static Future<ApiResponse<dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: decoded?['data'] ?? decoded,
          message: decoded?['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: decoded?['message'] ?? 'Error with status ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network connection issue: ${_getReadableError(e)}',
      );
    }
  }

  // DELETE request
  static Future<ApiResponse<dynamic>> delete(
    String url, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _getHeaders(requiresAuth: requiresAuth))
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: decoded?['data'] ?? decoded,
          message: decoded?['message'] ?? 'Deleted successfully',
        );
      } else {
        return ApiResponse(
          success: false,
          message: decoded?['message'] ?? 'Error with status ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network connection issue: ${_getReadableError(e)}',
      );
    }
  }

  static dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  static String _getReadableError(dynamic e) {
    if (e is SocketException) {
      return 'Unable to reach backend server. Check server connection or host settings.';
    }
    return e.toString();
  }
}
