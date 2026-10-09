import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardData? _data;
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;

  DashboardData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await DashboardService.getDashboard();
    _isLoading = false;
    if (res.success && res.data != null) {
      _data = res.data;
      _isOffline = res.isFromCache;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }
}
