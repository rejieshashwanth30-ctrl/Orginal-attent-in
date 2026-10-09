import '../models/timetable.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class TimetableService {
  static Future<ApiResponse<Map<String, List<TimetableSlot>>>> getTimetable() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: Map.from(MockDataService.timetable));
  }

  static Future<ApiResponse<TimetableSlot>> addSlot(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final day = data['dayOfWeek'] ?? 'Monday';
    final slot = TimetableSlot(
      id: 'tt-${DateTime.now().millisecondsSinceEpoch}',
      subjectId: data['subjectId'] ?? 'sub-1',
      subjectName: data['subjectName'] ?? 'Course Lecture',
      subjectCode: data['subjectCode'] ?? 'CS601',
      startTime: data['startTime'] ?? '09:00 AM',
      endTime: data['endTime'] ?? '10:00 AM',
      room: data['room'] ?? 'Room 101',
      faculty: data['faculty'] ?? 'Faculty Member',
      color: data['color'] ?? '#4F46E5',
    );

    if (!MockDataService.timetable.containsKey(day)) {
      MockDataService.timetable[day] = [];
    }
    MockDataService.timetable[day]!.add(slot);
    return ApiResponse(success: true, data: slot);
  }

  static Future<ApiResponse<dynamic>> deleteSlot(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    for (final list in MockDataService.timetable.values) {
      list.removeWhere((s) => s.id == id);
    }
    return ApiResponse(success: true, message: 'Deleted');
  }
}
