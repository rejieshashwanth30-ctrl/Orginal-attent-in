class InterviewQuestion {
  final String id;
  final String interviewId;
  final String question;
  final String? userAnswer;
  final String? feedback;
  final int score;

  InterviewQuestion({
    required this.id,
    required this.interviewId,
    required this.question,
    this.userAnswer,
    this.feedback,
    this.score = 0,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] ?? '',
      interviewId: json['interviewId'] ?? '',
      question: json['question'] ?? '',
      userAnswer: json['userAnswer'],
      feedback: json['feedback'],
      score: json['score'] is int ? json['score'] : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'interviewId': interviewId,
    'question': question,
    'userAnswer': userAnswer,
    'feedback': feedback,
    'score': score,
  };
}

class Interview {
  final String id;
  final String userId;
  final String role;
  final String difficulty;
  final String type;
  final int score;
  final String? strengths;
  final String? weaknesses;
  final String? suggestions;
  final DateTime createdAt;
  final List<InterviewQuestion> questions;

  Interview({
    required this.id,
    required this.userId,
    required this.role,
    required this.difficulty,
    required this.type,
    this.score = 0,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    required this.createdAt,
    this.questions = const [],
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    var qList = <InterviewQuestion>[];
    if (json['questions'] != null && json['questions'] is List) {
      qList = (json['questions'] as List)
          .map((q) => InterviewQuestion.fromJson(q))
          .toList();
    }

    return Interview(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? 'Flutter Developer',
      difficulty: json['difficulty'] ?? 'Medium',
      type: json['type'] ?? 'Technical',
      score: json['score'] is int ? json['score'] : 0,
      strengths: json['strengths'],
      weaknesses: json['weaknesses'],
      suggestions: json['suggestions'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      questions: qList,
    );
  }
}
