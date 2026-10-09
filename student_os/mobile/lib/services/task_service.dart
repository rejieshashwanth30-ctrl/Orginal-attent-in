import '../models/task.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class TaskService {
  static Future<ApiResponse<List<Task>>> getTasks({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.tasks;
    if (category != null && category != 'ALL' && category.isNotEmpty) {
      list = list.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<Task>> createTask({
    required String title,
    String? description,
    String category = 'ACADEMIC',
    String priority = 'MEDIUM',
    DateTime? dueDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final task = Task(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      title: title,
      description: description,
      category: category,
      priority: priority,
      isCompleted: false,
      dueDate: dueDate ?? DateTime.now(),
      createdAt: DateTime.now(),
    );
    MockDataService.tasks.insert(0, task);
    return ApiResponse(success: true, data: task);
  }

  static Future<ApiResponse<Task>> toggleTask(String id) async {
    return toggleComplete(id);
  }

  static Future<ApiResponse<Task>> toggleComplete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final old = MockDataService.tasks[index];
      final willComplete = !old.isCompleted;
      final updated = Task(
        id: old.id,
        userId: old.userId,
        title: old.title,
        description: old.description,
        category: old.category,
        priority: old.priority,
        isCompleted: willComplete,
        completedAt: willComplete ? DateTime.now() : null,
        dueDate: old.dueDate,
        createdAt: old.createdAt,
      );
      MockDataService.tasks[index] = updated;
      return ApiResponse(success: true, data: updated);
    }
    return ApiResponse(success: false, message: 'Task not found');
  }

  static Future<ApiResponse<dynamic>> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDataService.tasks.removeWhere((t) => t.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }
}
