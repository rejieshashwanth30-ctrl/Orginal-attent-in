import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await NotificationService.getNotifications();
    _isLoading = false;
    if (res.success && res.data != null) {
      _notifications = res.data!;
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final res = await NotificationService.markAsRead(id);
    if (res.success) {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          isRead: true,
          actionUrl: _notifications[index].actionUrl,
          createdAt: _notifications[index].createdAt,
        );
        _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final res = await NotificationService.markAllAsRead();
    if (res.success) {
      _notifications = _notifications.map((n) => AppNotification(
        id: n.id,
        userId: n.userId,
        title: n.title,
        message: n.message,
        type: n.type,
        isRead: true,
        actionUrl: n.actionUrl,
        createdAt: n.createdAt,
      )).toList();
      _unreadCount = 0;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    final res = await NotificationService.deleteNotification(id);
    if (res.success) {
      final wasUnread = _notifications.firstWhere((n) => n.id == id, orElse: () => _notifications.first).isRead == false;
      _notifications.removeWhere((n) => n.id == id);
      if (wasUnread && _unreadCount > 0) _unreadCount--;
      notifyListeners();
    }
  }
}
