import '../models/exam.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class ExamService {
  static Future<ApiResponse<List<Exam>>> getExams() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: List.from(MockDataService.exams));
  }

  static Future<ApiResponse<Exam>> createExam({
    required String subjectName,
    String type = 'INTERNAL',
    required DateTime date,
    required String startTime,
    required String endTime,
    required String room,
    String syllabus = '',
    int maxMarks = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final exam = Exam(
      id: 'exam-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      subjectName: subjectName,
      type: type,
      date: date,
      startTime: startTime,
      endTime: endTime,
      room: room,
      syllabus: syllabus,
      maxMarks: maxMarks,
    );
    MockDataService.exams.add(exam);
    return ApiResponse(success: true, data: exam);
  }
}
