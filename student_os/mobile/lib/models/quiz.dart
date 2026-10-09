enum QuizQuestionType {
  mcq,
  trueFalse,
  multipleSelect,
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final dynamic correctAnswer; // int index (0-3) or List<int> for multipleSelect, or bool for trueFalse
  final String explanation;
  final String topic;
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final QuizQuestionType questionType;

  // Runtime user state
  dynamic userSelection; // int, List<int>, or bool
  bool? isAnsweredCorrectly;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.topic,
    required this.difficulty,
    this.questionType = QuizQuestionType.mcq,
    this.userSelection,
    this.isAnsweredCorrectly,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    QuizQuestionType type = QuizQuestionType.mcq;
    final typeStr = json['questionType']?.toString().toLowerCase() ?? 'mcq';
    if (typeStr.contains('true') || typeStr.contains('tf')) {
      type = QuizQuestionType.trueFalse;
    } else if (typeStr.contains('multi') || typeStr.contains('select')) {
      type = QuizQuestionType.multipleSelect;
    }

    return QuizQuestion(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'] ?? '',
      topic: json['topic'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Medium',
      questionType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'topic': topic,
      'difficulty': difficulty,
      'questionType': questionType.name,
    };
  }
}

class Quiz {
  final String id;
  final String title;
  final String semester;
  final String subjectId;
  final String subjectName;
  final String topic;
  final String difficulty;
  final List<QuizQuestion> questions;
  final bool isAdaptive;
  final int timeLimitMinutes;
  final String? sourceNoteId;
  final String? sourceNoteTitle;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.semester,
    required this.subjectId,
    required this.subjectName,
    required this.topic,
    required this.difficulty,
    required this.questions,
    this.isAdaptive = false,
    this.timeLimitMinutes = 15,
    this.sourceNoteId,
    this.sourceNoteTitle,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalQuestions => questions.length;
}

class QuizResult {
  final String id;
  final String quizId;
  final String subjectName;
  final String topic;
  final int score;
  final int totalQuestions;
  final double percentage;
  final int correctCount;
  final int incorrectCount;
  final int timeTakenSeconds;
  final List<String> strongTopics;
  final List<String> weakTopics;
  final List<String> aiRecommendations;
  final String difficultyRecommendation;
  final String suggestedNextQuiz;
  final List<QuizQuestion> questions;
  final DateTime createdAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.subjectName,
    required this.topic,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.correctCount,
    required this.incorrectCount,
    required this.timeTakenSeconds,
    required this.strongTopics,
    required this.weakTopics,
    required this.aiRecommendations,
    required this.difficultyRecommendation,
    required this.suggestedNextQuiz,
    required this.questions,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get formattedTime {
    final minutes = timeTakenSeconds ~/ 60;
    final seconds = timeTakenSeconds % 60;
    if (minutes == 0) return '${seconds}s';
    return '$minutes min ${seconds > 0 ? '$seconds s' : ''}';
  }
}
