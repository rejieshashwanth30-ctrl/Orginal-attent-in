import '../models/interview.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class InterviewService {
  static Future<ApiResponse<List<Interview>>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: List.from(MockDataService.interviews));
  }

  static Future<ApiResponse<Interview>> startInterview({
    required String role,
    required String difficulty,
    required String type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final interviewId = 'intv-${DateTime.now().millisecondsSinceEpoch}';
    final questionMaps = _generateQuestionsForRole(role);

    final questions = questionMaps.map((q) {
      return InterviewQuestion(
        id: q['id'] as String,
        interviewId: interviewId,
        question: q['question'] as String,
      );
    }).toList();

    final interview = Interview(
      id: interviewId,
      userId: MockDataService.currentUser.id,
      role: role,
      difficulty: difficulty,
      type: type,
      score: 0,
      createdAt: DateTime.now(),
      questions: questions,
    );

    return ApiResponse(success: true, data: interview);
  }

  static Future<ApiResponse<Interview>> submitInterview({
    required String interviewId,
    required List<Map<String, dynamic>> answers,
    String? role,
    String? difficulty,
    String? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final evaluatedQuestions = answers.map((a) {
      final qId = a['questionId']?.toString() ?? 'q-1';
      final ansText = a['userAnswer']?.toString() ?? '';
      final wordCount = ansText.split(' ').length;
      final qScore = wordCount > 10 ? 88 : 75;

      return InterviewQuestion(
        id: qId,
        interviewId: interviewId,
        question: 'Technical Assessment Question',
        userAnswer: ansText,
        score: qScore,
        feedback: 'Good technical clarity and structured thought process.',
      );
    }).toList();

    final avgScore = evaluatedQuestions.isNotEmpty
        ? (evaluatedQuestions.fold<int>(0, (s, q) => s + q.score) / evaluatedQuestions.length).round()
        : 85;

    final interview = Interview(
      id: interviewId,
      userId: MockDataService.currentUser.id,
      role: role ?? 'Software Developer',
      difficulty: difficulty ?? 'Medium',
      type: type ?? 'Technical',
      score: avgScore,
      strengths: 'Strong core fundamentals, structured explanation, and familiarity with industry architectural patterns.',
      weaknesses: 'Can provide more granular analysis on time/space complexities and failure modes under extreme scale.',
      suggestions: 'Practice end-to-end live coding and diagramming distributed systems.',
      createdAt: DateTime.now(),
      questions: evaluatedQuestions,
    );

    MockDataService.interviews.insert(0, interview);
    return ApiResponse(success: true, data: interview);
  }

  static List<Map<String, dynamic>> _generateQuestionsForRole(String role) {
    if (role.toLowerCase().contains('flutter') || role.toLowerCase().contains('mobile')) {
      return [
        {
          'id': 'q1',
          'question': 'How does Flutter perform rendering pipeline passes (Build, Layout, Paint)? Explain the role of RenderObjects.',
        },
        {
          'id': 'q2',
          'question': 'What are the pros and cons of using Provider vs Bloc in a large-scale enterprise application?',
        },
        {
          'id': 'q3',
          'question': 'How do you handle background thread execution (Isolates) in Dart without blocking UI animations?',
        },
      ];
    } else if (role.toLowerCase().contains('ai') || role.toLowerCase().contains('ml') || role.toLowerCase().contains('machine')) {
      return [
        {
          'id': 'q1',
          'question': 'Explain the vanishing gradient problem in Deep Neural Networks and how modern architectures solve it.',
        },
        {
          'id': 'q2',
          'question': 'Describe the mathematical intuition behind Self-Attention mechanisms in Transformer models.',
        },
        {
          'id': 'q3',
          'question': 'How do you evaluate and optimize a model suffering from high variance (overfitting)?',
        },
      ];
    } else {
      return [
        {
          'id': 'q1',
          'question': 'Describe the design of a scalable URL shortener service (like bit.ly) handling 100M daily writes.',
        },
        {
          'id': 'q2',
          'question': 'Explain the difference between optimistic and pessimistic locking in relational databases.',
        },
        {
          'id': 'q3',
          'question': 'How do you implement distributed rate limiting across multiple stateless API gateway instances?',
        },
      ];
    }
  }
}
