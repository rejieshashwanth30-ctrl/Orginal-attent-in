import '../models/attendance.dart';
import '../models/subject.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class AttendanceService {
  static Future<ApiResponse<OverallAttendanceSummary>> getAttendanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 100));

    final totalAttended = MockDataService.subjects.fold<int>(0, (sum, s) => sum + s.attendedClasses);
    final totalClasses = MockDataService.subjects.fold<int>(0, (sum, s) => sum + s.totalClasses);
    final overallPct = totalClasses > 0 ? (totalAttended / totalClasses) * 100.0 : 0.0;
    final missed = totalClasses - totalAttended;

    final subjectBreakdown = MockDataService.subjects.map((s) {
      final sPct = s.totalClasses > 0 ? (s.attendedClasses / s.totalClasses) * 100.0 : 0.0;
      final sMissed = s.totalClasses - s.attendedClasses;
      final sNeeded = sPct < 75.0 ? ((0.75 * s.totalClasses - s.attendedClasses) / 0.25).ceil() : 0;
      final sCanMiss = sPct >= 75.0 ? ((s.attendedClasses - 0.75 * s.totalClasses) / 0.75).floor() : 0;

      return SubjectAttendance(
        subjectId: s.id,
        subjectName: s.name,
        subjectCode: s.code,
        faculty: s.faculty,
        color: s.color,
        totalClasses: s.totalClasses,
        attendedClasses: s.attendedClasses,
        missedClasses: sMissed,
        percentage: sPct,
        isLow: sPct < 75.0,
        classesNeeded: sNeeded,
        classesCanMiss: sCanMiss,
      );
    }).toList();

    final summary = OverallAttendanceSummary(
      overallPercentage: overallPct,
      totalClasses: totalClasses,
      attendedClasses: totalAttended,
      missedClasses: missed,
      overallNeeded: overallPct < 75.0 ? ((0.75 * totalClasses - totalAttended) / 0.25).ceil() : 0,
      overallCanMiss: overallPct >= 75.0 ? ((totalAttended - 0.75 * totalClasses) / 0.75).floor() : 0,
      subjects: subjectBreakdown,
    );

    return ApiResponse(success: true, data: summary);
  }

  static Future<ApiResponse<dynamic>> markAttendance({
    required String subjectId,
    required DateTime date,
    required String status,
    String? remarks,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.subjects.indexWhere((s) => s.id == subjectId);
    if (index != -1) {
      final s = MockDataService.subjects[index];
      final newTotal = s.totalClasses + 1;
      final newAttended = status == 'PRESENT' ? s.attendedClasses + 1 : s.attendedClasses;
      MockDataService.subjects[index] = Subject(
        id: s.id,
        userId: s.userId,
        name: s.name,
        code: s.code,
        credits: s.credits,
        faculty: s.faculty,
        color: s.color,
        totalClasses: newTotal,
        attendedClasses: newAttended,
      );
    }
    return ApiResponse(success: true, message: 'Attendance marked as $status');
  }
}
