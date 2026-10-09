import 'package:flutter/material.dart';
import '../models/cgpa_models.dart';

class CgpaProvider extends ChangeNotifier {
  List<SemesterRecord> _semesters = [];
  final GradingScale _gradingScale = GradingScale.defaultScale();
  int _selectedSemesterIndex = 0;

  CgpaProvider() {
    _initMockSemesters();
  }

  List<SemesterRecord> get semesters => _semesters;
  GradingScale get gradingScale => _gradingScale;
  int get selectedSemesterIndex => _selectedSemesterIndex;

  SemesterRecord get currentSemester =>
      _semesters.isNotEmpty ? _semesters[_selectedSemesterIndex.clamp(0, _semesters.length - 1)] : _semesters.first;

  int get totalCompletedCredits {
    return _semesters
        .where((s) => s.isCompleted)
        .fold(0, (sum, s) => sum + s.totalCredits);
  }

  double get overallCgpa {
    final completed = _semesters.where((s) => s.isCompleted).toList();
    if (completed.isEmpty) return 0.0;
    int totalCredits = 0;
    double weightedGpaSum = 0.0;

    for (final sem in completed) {
      if (sem.totalCredits > 0) {
        totalCredits += sem.totalCredits;
        weightedGpaSum += (sem.semesterGpa * sem.totalCredits);
      }
    }

    if (totalCredits == 0) return 0.0;
    return double.parse((weightedGpaSum / totalCredits).toStringAsFixed(2));
  }

  String get standingDescription {
    final cgpa = overallCgpa;
    if (cgpa >= 9.0) return 'Distinction / Exemplary';
    if (cgpa >= 8.0) return 'First Class with Honors';
    if (cgpa >= 6.5) return 'First Class';
    if (cgpa >= 5.0) return 'Second Class';
    return 'Needs Improvement';
  }

  void setSelectedSemester(int index) {
    if (index >= 0 && index < _semesters.length) {
      _selectedSemesterIndex = index;
      notifyListeners();
    }
  }

  void addSubjectToCurrentSemester({
    required String name,
    required String code,
    required int credits,
    required String grade,
  }) {
    final gradePoint = _gradingScale.scale[grade] ?? 8.0;
    final newSubject = SubjectGrade(
      id: 'sub-${DateTime.now().millisecondsSinceEpoch}',
      subjectName: name,
      subjectCode: code,
      credits: credits,
      grade: grade,
      gradePoint: gradePoint,
    );

    final current = _semesters[_selectedSemesterIndex];
    final updatedList = List<SubjectGrade>.from(current.subjects)..add(newSubject);
    _semesters[_selectedSemesterIndex] = current.copyWith(subjects: updatedList);
    notifyListeners();
  }

  void updateSubjectGrade(int semIndex, String subjectId, String newGrade) {
    final sem = _semesters[semIndex];
    final subIdx = sem.subjects.indexWhere((s) => s.id == subjectId);
    if (subIdx != -1) {
      final oldSub = sem.subjects[subIdx];
      final gradePoint = _gradingScale.scale[newGrade] ?? 8.0;
      final updatedSub = oldSub.copyWith(grade: newGrade, gradePoint: gradePoint);

      final updatedList = List<SubjectGrade>.from(sem.subjects);
      updatedList[subIdx] = updatedSub;
      _semesters[semIndex] = sem.copyWith(subjects: updatedList);
      notifyListeners();
    }
  }

  void deleteSubject(int semIndex, String subjectId) {
    final sem = _semesters[semIndex];
    final updatedList = sem.subjects.where((s) => s.id != subjectId).toList();
    _semesters[semIndex] = sem.copyWith(subjects: updatedList);
    notifyListeners();
  }

  /// Calculates what average GPA is needed across `remainingCredits` to reach `targetCgpa`.
  double? calculateRequiredGpaForTarget({
    required double targetCgpa,
    required int remainingCredits,
  }) {
    final currentCredits = totalCompletedCredits;
    final currentCgpa = overallCgpa;
    final totalTargetCredits = currentCredits + remainingCredits;

    if (remainingCredits <= 0 || totalTargetCredits == 0) return null;

    final targetTotalPoints = targetCgpa * totalTargetCredits;
    final currentTotalPoints = currentCgpa * currentCredits;
    final requiredPoints = targetTotalPoints - currentTotalPoints;

    final requiredGpa = requiredPoints / remainingCredits;
    return double.parse(requiredGpa.toStringAsFixed(2));
  }

  /// AI Scenario Simulation
  double simulateFutureCgpa(List<Map<String, dynamic>> simulatedSubjects) {
    int simCredits = 0;
    double simPoints = 0.0;

    for (final s in simulatedSubjects) {
      final cred = (s['credits'] as int?) ?? 3;
      final gr = (s['grade'] as String?) ?? 'A';
      final gp = _gradingScale.scale[gr] ?? 9.0;
      simCredits += cred;
      simPoints += (cred * gp);
    }

    final currentCredits = totalCompletedCredits;
    final currentPoints = overallCgpa * currentCredits;
    final totalCredits = currentCredits + simCredits;

    if (totalCredits == 0) return overallCgpa;
    return double.parse(((currentPoints + simPoints) / totalCredits).toStringAsFixed(2));
  }

  void _initMockSemesters() {
    _semesters = [
      SemesterRecord(
        semesterNumber: 1,
        semesterName: 'Semester 1',
        isCompleted: true,
        subjects: [
          SubjectGrade(id: 's1-1', subjectName: 'Engineering Mathematics I', subjectCode: 'MAT101', credits: 4, grade: 'S', gradePoint: 10.0),
          SubjectGrade(id: 's1-2', subjectName: 'Problem Solving & C Programming', subjectCode: 'CSE101', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's1-3', subjectName: 'Engineering Physics & Lab', subjectCode: 'PHY101', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's1-4', subjectName: 'Basic Electrical Engineering', subjectCode: 'EEE101', credits: 3, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's1-5', subjectName: 'Technical Communication Skills', subjectCode: 'ENG101', credits: 2, grade: 'S', gradePoint: 10.0),
        ],
      ),
      SemesterRecord(
        semesterNumber: 2,
        semesterName: 'Semester 2',
        isCompleted: true,
        subjects: [
          SubjectGrade(id: 's2-1', subjectName: 'Discrete Mathematics & Graph Theory', subjectCode: 'MAT201', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's2-2', subjectName: 'Data Structures and Algorithms', subjectCode: 'CSE201', credits: 4, grade: 'S', gradePoint: 10.0),
          SubjectGrade(id: 's2-3', subjectName: 'Digital Logic & Computer Design', subjectCode: 'CSE202', credits: 4, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's2-4', subjectName: 'Object Oriented Programming (Java/C++)', subjectCode: 'CSE203', credits: 3, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's2-5', subjectName: 'Environmental Science & Ethics', subjectCode: 'ENV101', credits: 2, grade: 'A', gradePoint: 9.0),
        ],
      ),
      SemesterRecord(
        semesterNumber: 3,
        semesterName: 'Semester 3',
        isCompleted: true,
        subjects: [
          SubjectGrade(id: 's3-1', subjectName: 'Design & Analysis of Algorithms', subjectCode: 'CSE301', credits: 4, grade: 'S', gradePoint: 10.0),
          SubjectGrade(id: 's3-2', subjectName: 'Database Management Systems & SQL', subjectCode: 'CSE302', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's3-3', subjectName: 'Computer Architecture & Org', subjectCode: 'CSE303', credits: 3, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's3-4', subjectName: 'Probability & Statistics for CS', subjectCode: 'MAT301', credits: 3, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's3-5', subjectName: 'Web Technologies Lab', subjectCode: 'CSE304', credits: 2, grade: 'S', gradePoint: 10.0),
        ],
      ),
      SemesterRecord(
        semesterNumber: 4,
        semesterName: 'Semester 4',
        isCompleted: true,
        subjects: [
          SubjectGrade(id: 's4-1', subjectName: 'Operating Systems & Concurrency', subjectCode: 'CSE401', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's4-2', subjectName: 'Computer Networks & Protocols', subjectCode: 'CSE402', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's4-3', subjectName: 'Theory of Computation & Automata', subjectCode: 'CSE403', credits: 3, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's4-4', subjectName: 'Software Engineering & Agile', subjectCode: 'CSE404', credits: 3, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's4-5', subjectName: 'Mini Project Lab (Full-Stack)', subjectCode: 'CSE405', credits: 2, grade: 'S', gradePoint: 10.0),
        ],
      ),
      SemesterRecord(
        semesterNumber: 5,
        semesterName: 'Semester 5 (Current)',
        isCompleted: false,
        subjects: [
          SubjectGrade(id: 's5-1', subjectName: 'Machine Learning & Neural Networks', subjectCode: 'CSE501', credits: 4, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's5-2', subjectName: 'Compiler Design & Lexing', subjectCode: 'CSE502', credits: 4, grade: 'B', gradePoint: 8.0),
          SubjectGrade(id: 's5-3', subjectName: 'Cloud Computing & Distributed Sys', subjectCode: 'CSE503', credits: 3, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's5-4', subjectName: 'Information Security & Cryptography', subjectCode: 'CSE504', credits: 3, grade: 'A', gradePoint: 9.0),
          SubjectGrade(id: 's5-5', subjectName: 'AI & Data Science Lab', subjectCode: 'CSE505', credits: 2, grade: 'S', gradePoint: 10.0),
        ],
      ),
    ];
  }
}
