import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../services/assignment_service.dart';

class AssignmentProvider extends ChangeNotifier {
  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String? _error;
  String _activeFilter = 'ALL';

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get activeFilter => _activeFilter;

  List<Assignment> get filteredAssignments {
    if (_activeFilter == 'ALL') return _assignments;
    if (_activeFilter == 'PENDING') return _assignments.where((a) => a.status == 'PENDING').toList();
    if (_activeFilter == 'IN_PROGRESS') return _assignments.where((a) => a.status == 'IN_PROGRESS').toList();
    if (_activeFilter == 'COMPLETED') return _assignments.where((a) => a.status == 'COMPLETED').toList();
    if (_activeFilter == 'OVERDUE') return _assignments.where((a) => a.isOverdue).toList();
    return _assignments;
  }

  Future<void> fetchAssignments({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await AssignmentService.getAssignments(status: status ?? _activeFilter);
    _isLoading = false;
    if (res.success && res.data != null) {
      _assignments = res.data!;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<bool> createAssignment({
    String? subjectId,
    required String title,
    String? description,
    required DateTime dueDate,
    String priority = 'MEDIUM',
    int maxMarks = 100,
  }) async {
    final res = await AssignmentService.createAssignment(
      subjectId: subjectId,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      maxMarks: maxMarks,
    );

    if (res.success && res.data != null) {
      _assignments.insert(0, res.data!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateStatus(String id, String status) async {
    final res = await AssignmentService.updateAssignmentStatus(id, status);
    if (res.success) {
      await fetchAssignments();
      return true;
    }
    return false;
  }

  Future<bool> deleteAssignment(String id) async {
    final res = await AssignmentService.deleteAssignment(id);
    if (res.success) {
      _assignments.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}
