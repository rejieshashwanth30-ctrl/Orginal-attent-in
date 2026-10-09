import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      _user = StorageService.getUser();
      _status = AuthStatus.authenticated;
      notifyListeners();

      // Silent refresh
      final res = await AuthService.getMe();
      if (res.success && res.data != null) {
        _user = res.data;
        notifyListeners();
      }
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final res = await AuthService.login(email, password);
    if (res.success && res.data != null) {
      _user = res.data;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = res.message ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginDemo({bool asAdmin = false}) async {
    final email = asAdmin ? AppConstants.demoAdminEmail : AppConstants.demoStudentEmail;
    final password = asAdmin ? AppConstants.demoAdminPassword : AppConstants.demoStudentPassword;
    return await login(email, password);
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? college,
    String? department,
    int? year,
    String? rollNumber,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final res = await AuthService.register(
      email: email,
      password: password,
      fullName: fullName,
      college: college,
      department: department,
      year: year,
      rollNumber: rollNumber,
    );

    if (res.success && res.data != null) {
      _user = res.data;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = res.message ?? 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void updateUserProfile(Profile updatedProfile) {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        email: _user!.email,
        role: _user!.role,
        profile: updatedProfile,
      );
      StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final res = await AuthService.updateProfile(data);
    if (res.success && res.data != null) {
      updateUserProfile(res.data!);
      return true;
    }
    return false;
  }
}
