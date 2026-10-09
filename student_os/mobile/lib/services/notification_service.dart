import '../models/notification.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class NotificationService {
  static Future<ApiResponse<List<AppNotification>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: List.from(MockDataService.notifications));
  }

  static Future<ApiResponse<dynamic>> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = MockDataService.notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = MockDataService.notifications[index];
      MockDataService.notifications[index] = AppNotification(
        id: old.id,
        userId: old.userId,
        title: old.title,
        message: old.message,
        type: old.type,
        isRead: true,
        actionUrl: old.actionUrl,
        createdAt: old.createdAt,
      );
    }
    return ApiResponse(success: true, message: 'Marked read');
  }

  static Future<ApiResponse<dynamic>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 50));
    for (int i = 0; i < MockDataService.notifications.length; i++) {
      final old = MockDataService.notifications[i];
      MockDataService.notifications[i] = AppNotification(
        id: old.id,
        userId: old.userId,
        title: old.title,
        message: old.message,
        type: old.type,
        isRead: true,
        actionUrl: old.actionUrl,
        createdAt: old.createdAt,
      );
    }
    return ApiResponse(success: true, message: 'All marked read');
  }

  static Future<ApiResponse<dynamic>> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    MockDataService.notifications.removeWhere((n) => n.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }
}
