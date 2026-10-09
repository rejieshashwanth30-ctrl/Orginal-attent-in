import '../models/assignment.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class AssignmentService {
  static Future<ApiResponse<List<Assignment>>> getAssignments({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.assignments;
    if (status != null && status != 'ALL' && status.isNotEmpty) {
      if (status == 'OVERDUE') {
        list = list.where((a) => a.isOverdue).toList();
      } else {
        list = list.where((a) => a.status.toUpperCase() == status.toUpperCase()).toList();
      }
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<Assignment>> createAssignment({
    String? subjectId,
    required String title,
    String? description,
    required DateTime dueDate,
    String priority = 'MEDIUM',
    int maxMarks = 100,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final sub = MockDataService.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => MockDataService.subjects.first,
    );
    final asgn = Assignment(
      id: 'asgn-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      subjectId: subjectId,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: 'PENDING',
      maxMarks: maxMarks,
      subject: sub,
    );
    MockDataService.assignments.insert(0, asgn);
    return ApiResponse(success: true, data: asgn);
  }

  static Future<ApiResponse<Assignment>> updateAssignmentStatus(String id, String status) async {
    return updateStatus(id, status);
  }

  static Future<ApiResponse<Assignment>> updateStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final old = MockDataService.assignments[index];
      final updated = Assignment(
        id: old.id,
        userId: old.userId,
        subjectId: old.subjectId,
        title: old.title,
        description: old.description,
        dueDate: old.dueDate,
        priority: old.priority,
        status: status,
        maxMarks: old.maxMarks,
        submissionUrl: old.submissionUrl,
        subject: old.subject,
      );
      MockDataService.assignments[index] = updated;
      return ApiResponse(success: true, data: updated);
    }
    return ApiResponse(success: false, message: 'Assignment not found');
  }

  static Future<ApiResponse<dynamic>> deleteAssignment(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDataService.assignments.removeWhere((a) => a.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }
}
