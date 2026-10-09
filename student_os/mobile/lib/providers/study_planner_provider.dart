import 'package:flutter/material.dart';
import '../models/study_plan.dart';
import '../services/study_planner_service.dart';

class StudyPlannerProvider extends ChangeNotifier {
  StudyPlan? _plan;
  StudyAnalytics? _analytics;
  bool _isLoading = false;
  String? _error;

  StudyPlan? get plan => _plan;
  StudyAnalytics? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStudyPlan() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await StudyPlannerService.getActivePlan();
    _isLoading = false;
    if (res.success && res.data != null) {
      _plan = res.data!.plan;
      _analytics = res.data!.analytics;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  Future<bool> generatePlan({
    required String title,
    DateTime? targetDate,
    double availableHoursDaily = 3.0,
    String weakSubjects = '',
    String preferredTime = 'EVENING',
    List<String>? selectedSubjects,
  }) async {
    _isLoading = true;
    notifyListeners();

    final res = await StudyPlannerService.generatePlan(
      title: title,
      targetDate: targetDate,
      availableHoursDaily: availableHoursDaily,
      weakSubjects: weakSubjects,
      preferredTime: preferredTime,
      selectedSubjects: selectedSubjects,
    );

    _isLoading = false;
    if (res.success && res.data != null) {
      await fetchStudyPlan();
      return true;
    }
    _error = res.message;
    notifyListeners();
    return false;
  }

  Future<void> toggleSession(String sessionId) async {
    await StudyPlannerService.toggleSession(sessionId);
    await fetchStudyPlan();
  }
}
