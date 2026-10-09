import 'subject.dart';

class Assignment {
  final String id;
  final String userId;
  final String? subjectId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority; // LOW, MEDIUM, HIGH
  final String status;   // PENDING, IN_PROGRESS, COMPLETED, OVERDUE
  final int maxMarks;
  final String? submissionUrl;
  final Subject? subject;

  Assignment({
    required this.id,
    required this.userId,
    this.subjectId,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = 'MEDIUM',
    this.status = 'PENDING',
    this.maxMarks = 100,
    this.submissionUrl,
    this.subject,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subjectId: json['subjectId'],
      title: json['title'] ?? '',
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now(),
      priority: json['priority'] ?? 'MEDIUM',
      status: json['status'] ?? 'PENDING',
      maxMarks: json['maxMarks'] is int ? json['maxMarks'] : 100,
      submissionUrl: json['submissionUrl'],
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'maxMarks': maxMarks,
      'submissionUrl': submissionUrl,
    };
  }

  bool get isOverdue {
    if (status == 'COMPLETED') return false;
    return dueDate.isBefore(DateTime.now());
  }

  String get subjectName => subject?.name ?? 'General Course';
}
