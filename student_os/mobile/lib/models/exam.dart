import 'subject.dart';

class Exam {
  final String id;
  final String userId;
  final String? subjectId;
  final String subjectName;
  final String type; // INTERNAL, MODEL, LAB, SEMESTER
  final DateTime date;
  final String startTime;
  final String endTime;
  final String room;
  final String? syllabus;
  final int maxMarks;
  final int daysRemaining;
  final String countdownText;
  final bool isPast;
  final Subject? subject;

  Exam({
    required this.id,
    required this.userId,
    this.subjectId,
    required this.subjectName,
    required this.type,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.syllabus,
    this.maxMarks = 100,
    this.daysRemaining = 0,
    this.countdownText = '',
    this.isPast = false,
    this.subject,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subjectId: json['subjectId'],
      subjectName: json['subjectName'] ?? '',
      type: json['type'] ?? 'INTERNAL',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      startTime: json['startTime'] ?? '10:00 AM',
      endTime: json['endTime'] ?? '01:00 PM',
      room: json['room'] ?? 'Hall A',
      syllabus: json['syllabus'],
      maxMarks: json['maxMarks'] is int ? json['maxMarks'] : 100,
      daysRemaining: json['daysRemaining'] is int ? json['daysRemaining'] : 0,
      countdownText: json['countdownText'] ?? '',
      isPast: json['isPast'] ?? false,
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'type': type,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'syllabus': syllabus,
      'maxMarks': maxMarks,
    };
  }
}
