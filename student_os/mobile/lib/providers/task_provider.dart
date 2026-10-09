import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  String _activeCategory = 'ALL';

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get activeCategory => _activeCategory;

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }

  List<Task> get upcomingTasks {
    return _tasks.where((t) => !t.isCompleted).toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((t) => t.isCompleted).toList();
  }

  Future<void> fetchTasks({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await TaskService.getTasks(category: category ?? _activeCategory);
    _isLoading = false;
    if (res.success && res.data != null) {
      _tasks = res.data!;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _activeCategory = category;
    notifyListeners();
  }

  Future<bool> createTask({
    required String title,
    String? description,
    String category = 'ACADEMIC',
    String priority = 'MEDIUM',
    DateTime? dueDate,
  }) async {
    final res = await TaskService.createTask(
      title: title,
      description: description,
      category: category,
      priority: priority,
      dueDate: dueDate,
    );

    if (res.success && res.data != null) {
      _tasks.insert(0, res.data!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> toggleTask(String id) async {
    final res = await TaskService.toggleTask(id);
    if (res.success && res.data != null) {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = res.data!;
        notifyListeners();
      }
    }
  }

  Future<bool> deleteTask(String id) async {
    final res = await TaskService.deleteTask(id);
    if (res.success) {
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}
