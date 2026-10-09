import 'assignment.dart';
import 'exam.dart';
import 'timetable.dart';

class DashboardData {
  final String greetingName;
  final double attendancePercentage;
  final int pendingAssignmentsCount;
  final int upcomingExamsCount;
  final double studyHours;
  final double gpa;
  final int careerReadiness;
  final List<TimetableSlot> todaysClasses;
  final List<Assignment> urgentAssignments;
  final List<Exam> nextExams;
  final int notificationsCount;

  DashboardData({
    required this.greetingName,
    required this.attendancePercentage,
    required this.pendingAssignmentsCount,
    required this.upcomingExamsCount,
    required this.studyHours,
    required this.gpa,
    required this.careerReadiness,
    required this.todaysClasses,
    required this.urgentAssignments,
    required this.nextExams,
    this.notificationsCount = 0,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      greetingName: json['greetingName'] ?? 'Student',
      attendancePercentage: (json['attendancePercentage'] != null) ? (json['attendancePercentage'] as num).toDouble() : 85.0,
      pendingAssignmentsCount: json['pendingAssignmentsCount'] is int ? json['pendingAssignmentsCount'] : 0,
      upcomingExamsCount: json['upcomingExamsCount'] is int ? json['upcomingExamsCount'] : 0,
      studyHours: (json['studyHours'] != null) ? (json['studyHours'] as num).toDouble() : 18.5,
      gpa: (json['gpa'] != null) ? (json['gpa'] as num).toDouble() : 8.5,
      careerReadiness: json['careerReadiness'] is int ? json['careerReadiness'] : 75,
      todaysClasses: (json['todaysClasses'] as List<dynamic>?)?.map((x) => TimetableSlot.fromJson(x)).toList() ?? [],
      urgentAssignments: (json['urgentAssignments'] as List<dynamic>?)?.map((x) => Assignment.fromJson(x)).toList() ?? [],
      nextExams: (json['nextExams'] as List<dynamic>?)?.map((x) => Exam.fromJson(x)).toList() ?? [],
      notificationsCount: json['notificationsCount'] is int ? json['notificationsCount'] : 0,
    );
  }
}
