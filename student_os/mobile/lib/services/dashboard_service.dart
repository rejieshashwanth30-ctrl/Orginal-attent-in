import '../models/dashboard_data.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class DashboardService {
  static Future<ApiResponse<DashboardData>> getDashboard() async {
    await Future.delayed(const Duration(milliseconds: 100));

    final totalAttended = MockDataService.subjects.fold<int>(0, (sum, s) => sum + s.attendedClasses);
    final totalClasses = MockDataService.subjects.fold<int>(0, (sum, s) => sum + s.totalClasses);
    final attPct = totalClasses > 0 ? (totalAttended / totalClasses) * 100.0 : 87.0;

    final todayClasses = MockDataService.timetable['Monday'] ?? [];
    final pendingAssignments = MockDataService.assignments.where((a) => a.status != 'COMPLETED').toList();

    final data = DashboardData(
      greetingName: MockDataService.currentUser.profile?.fullName ?? 'Aarav Sharma',
      attendancePercentage: attPct,
      pendingAssignmentsCount: pendingAssignments.length,
      upcomingExamsCount: MockDataService.exams.length,
      studyHours: 18.5,
      gpa: MockDataService.currentUser.profile?.gpa ?? 8.7,
      careerReadiness: MockDataService.currentUser.profile?.careerScore ?? 78,
      todaysClasses: todayClasses,
      urgentAssignments: pendingAssignments.take(3).toList(),
      nextExams: MockDataService.exams.take(3).toList(),
      notificationsCount: MockDataService.notifications.where((n) => !n.isRead).length,
    );

    return ApiResponse(success: true, data: data);
  }
}
