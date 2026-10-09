import '../models/calendar_event.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class CalendarService {
  static Future<ApiResponse<List<CalendarEventModel>>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: List.from(MockDataService.calendarEvents));
  }

  static Future<ApiResponse<CalendarEventModel>> createEvent({
    required String title,
    String? description,
    String? location,
    required DateTime startTime,
    DateTime? endTime,
    String category = 'CLASS',
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final ev = CalendarEventModel(
      id: 'cal-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      title: title,
      description: description,
      location: location,
      startTime: startTime,
      endTime: endTime ?? startTime.add(const Duration(hours: 1)),
      category: category,
    );
    MockDataService.calendarEvents.add(ev);
    return ApiResponse(success: true, data: ev);
  }

  static Future<ApiResponse<dynamic>> deleteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDataService.calendarEvents.removeWhere((e) => e.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }
}
