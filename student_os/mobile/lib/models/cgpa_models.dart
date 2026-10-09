class SubjectGrade {
  final String id;
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String grade; // e.g. "S", "A", "B", "C", "D", "E", "F"
  final double gradePoint;

  SubjectGrade({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    required this.grade,
    required this.gradePoint,
  });

  SubjectGrade copyWith({
    String? subjectName,
    String? subjectCode,
    int? credits,
    String? grade,
    double? gradePoint,
  }) {
    return SubjectGrade(
      id: id,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      credits: credits ?? this.credits,
      grade: grade ?? this.grade,
      gradePoint: gradePoint ?? this.gradePoint,
    );
  }
}

class SemesterRecord {
  final int semesterNumber;
  final String semesterName;
  final List<SubjectGrade> subjects;
  final bool isCompleted;

  SemesterRecord({
    required this.semesterNumber,
    required this.semesterName,
    required this.subjects,
    this.isCompleted = true,
  });

  int get totalCredits => subjects.fold(0, (sum, s) => sum + s.credits);

  double get semesterGpa {
    if (totalCredits == 0) return 0.0;
    final totalPoints = subjects.fold(0.0, (sum, s) => sum + (s.credits * s.gradePoint));
    return double.parse((totalPoints / totalCredits).toStringAsFixed(2));
  }

  SemesterRecord copyWith({
    List<SubjectGrade>? subjects,
    bool? isCompleted,
  }) {
    return SemesterRecord(
      semesterNumber: semesterNumber,
      semesterName: semesterName,
      subjects: subjects ?? this.subjects,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class GradingScale {
  final Map<String, double> scale;

  GradingScale({required this.scale});

  static GradingScale defaultScale() {
    return GradingScale(
      scale: {
        'S': 10.0,
        'A': 9.0,
        'B': 8.0,
        'C': 7.0,
        'D': 6.0,
        'E': 5.0,
        'F': 0.0,
      },
    );
  }
}
