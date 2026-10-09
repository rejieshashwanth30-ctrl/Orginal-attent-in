import '../models/study_plan.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class StudyPlannerResponse {
  final StudyPlan plan;
  final StudyAnalytics analytics;

  StudyPlannerResponse({required this.plan, required this.analytics});
}

class StudyPlannerService {
  static Future<ApiResponse<StudyPlannerResponse>> getActivePlan() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final plan = MockDataService.studyPlan;
    final totalCompleted = plan.sessions.where((s) => s.isCompleted).length;
    final totalSessions = plan.sessions.isNotEmpty ? plan.sessions.length : 1;
    final compPct = (totalCompleted / totalSessions) * 100.0;

    final analytics = StudyAnalytics(
      weeklyStudyHours: 18.5,
      completedHours: 8.5,
      completionPercentage: compPct,
      subjectDistribution: {
        'Machine Learning': 35,
        'Cloud Computing': 25,
        'Compiler Design': 20,
        'Mobile App Eng': 20,
      },
    );

    return ApiResponse(
      success: true,
      data: StudyPlannerResponse(plan: plan, analytics: analytics),
    );
  }

  static Future<ApiResponse<StudyPlan>> generatePlan({
    required String title,
    DateTime? targetDate,
    double availableHoursDaily = 3.0,
    String weakSubjects = '',
    String preferredTime = 'EVENING',
    List<String>? selectedSubjects,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final subjectsToFocus = selectedSubjects != null && selectedSubjects.isNotEmpty
        ? MockDataService.subjects.where((s) => selectedSubjects.contains(s.id)).toList()
        : MockDataService.subjects;

    final newSessions = <StudySession>[];
    for (int i = 0; i < 7; i++) {
      final sub = subjectsToFocus[i % subjectsToFocus.length];
      newSessions.add(
        StudySession(
          id: 'sess-gen-$i',
          studyPlanId: MockDataService.studyPlan.id,
          subject: sub.name,
          durationMinutes: (availableHoursDaily * 60 / 2).round().clamp(30, 90),
          date: DateTime.now().add(Duration(days: (i / 2).floor())),
          isCompleted: false,
          notes: 'Master core theorems, practice problem sets, and review past exam questions.',
        ),
      );
    }

    final newPlan = StudyPlan(
      id: 'sp-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      title: title.isNotEmpty ? title : 'AI-Generated Revision Roadmap',
      targetDate: targetDate ?? DateTime.now().add(const Duration(days: 30)),
      availableHoursDaily: availableHoursDaily,
      weakSubjects: weakSubjects.isNotEmpty ? weakSubjects : subjectsToFocus.map((s) => s.name).join(', '),
      preferredTime: preferredTime,
      sessions: newSessions,
    );

    MockDataService.studyPlan = newPlan;
    return ApiResponse(success: true, data: newPlan);
  }

  static Future<ApiResponse<dynamic>> toggleSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final plan = MockDataService.studyPlan;
    final index = plan.sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      final old = plan.sessions[index];
      plan.sessions[index] = StudySession(
        id: old.id,
        studyPlanId: old.studyPlanId,
        subject: old.subject,
        durationMinutes: old.durationMinutes,
        date: old.date,
        isCompleted: !old.isCompleted,
        notes: old.notes,
      );
      return ApiResponse(success: true, message: 'Updated');
    }
    return ApiResponse(success: false, message: 'Session not found');
  }
}
