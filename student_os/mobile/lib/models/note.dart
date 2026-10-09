import 'subject.dart';

class Note {
  final String id;
  final String userId;
  final String? subjectId;
  final String title;
  final String content;
  final String tags;
  final bool isPinned;
  final String color;
  final DateTime updatedAt;
  final Subject? subject;

  Note({
    required this.id,
    required this.userId,
    this.subjectId,
    required this.title,
    required this.content,
    this.tags = '',
    this.isPinned = false,
    this.color = '#F3F4F6',
    required this.updatedAt,
    this.subject,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subjectId: json['subjectId'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: json['tags'] ?? '',
      isPinned: json['isPinned'] ?? false,
      color: json['color'] ?? '#F3F4F6',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subjectId': subjectId,
      'title': title,
      'content': content,
      'tags': tags,
      'isPinned': isPinned,
      'color': color,
    };
  }

  List<String> get tagList {
    if (tags.isEmpty) return [];
    return tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
  }
}
