import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  OverallAttendanceSummary? _summary;
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;

  OverallAttendanceSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;

  Future<void> fetchAttendance() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await AttendanceService.getAttendanceSummary();
    _isLoading = false;
    if (res.success && res.data != null) {
      _summary = res.data;
      _isOffline = res.isFromCache;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  Future<bool> markAttendance({
    required String subjectId,
    required DateTime date,
    required String status,
    String? remarks,
  }) async {
    final res = await AttendanceService.markAttendance(
      subjectId: subjectId,
      date: date,
      status: status,
      remarks: remarks,
    );

    if (res.success) {
      await fetchAttendance();
      return true;
    }
    return false;
  }
}
