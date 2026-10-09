class StudySession {
  final String id;
  final String studyPlanId;
  final String subject;
  final DateTime date;
  final int durationMinutes;
  final bool isCompleted;
  final String? notes;

  StudySession({
    required this.id,
    required this.studyPlanId,
    required this.subject,
    required this.date,
    this.durationMinutes = 60,
    this.isCompleted = false,
    this.notes,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'] ?? '',
      studyPlanId: json['studyPlanId'] ?? '',
      subject: json['subject'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      durationMinutes: json['durationMinutes'] is int ? json['durationMinutes'] : 60,
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studyPlanId': studyPlanId,
      'subject': subject,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }
}

class StudyPlan {
  final String id;
  final String userId;
  final String title;
  final DateTime targetDate;
  final double availableHoursDaily;
  final String weakSubjects;
  final String preferredTime;
  final double completionRate;
  final List<StudySession> sessions;

  StudyPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetDate,
    this.availableHoursDaily = 3.0,
    this.weakSubjects = '',
    this.preferredTime = 'EVENING',
    this.completionRate = 0.0,
    this.sessions = const [],
  });

  factory StudyPlan.fromJson(Map<String, dynamic> json) {
    var sessList = <StudySession>[];
    if (json['sessions'] != null && json['sessions'] is List) {
      sessList = (json['sessions'] as List)
          .map((s) => StudySession.fromJson(s))
          .toList();
    }

    return StudyPlan(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'Intelligent Study Plan',
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : DateTime.now(),
      availableHoursDaily: (json['availableHoursDaily'] != null) ? (json['availableHoursDaily'] as num).toDouble() : 3.0,
      weakSubjects: json['weakSubjects'] ?? '',
      preferredTime: json['preferredTime'] ?? 'EVENING',
      completionRate: (json['completionRate'] != null) ? (json['completionRate'] as num).toDouble() : 0.0,
      sessions: sessList,
    );
  }
}

class StudyAnalytics {
  final double weeklyStudyHours;
  final double completedHours;
  final double completionPercentage;
  final Map<String, int> subjectDistribution;

  StudyAnalytics({
    required this.weeklyStudyHours,
    required this.completedHours,
    required this.completionPercentage,
    required this.subjectDistribution,
  });

  factory StudyAnalytics.fromJson(Map<String, dynamic> json) {
    final distMap = <String, int>{};
    if (json['subjectDistribution'] != null && json['subjectDistribution'] is Map) {
      (json['subjectDistribution'] as Map).forEach((k, v) {
        distMap[k.toString()] = (v is num) ? v.toInt() : 0;
      });
    }

    return StudyAnalytics(
      weeklyStudyHours: (json['weeklyStudyHours'] != null) ? (json['weeklyStudyHours'] as num).toDouble() : 18.5,
      completedHours: (json['completedHours'] != null) ? (json['completedHours'] as num).toDouble() : 8.0,
      completionPercentage: (json['completionPercentage'] != null) ? (json['completionPercentage'] as num).toDouble() : 45.0,
      subjectDistribution: distMap,
    );
  }
}
