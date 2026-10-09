class CalendarEventModel {
  final String id;
  final String? originalId;
  final String userId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String category; // CLASS, ASSIGNMENT, EXAM, TASK, HACKATHON, INTERNSHIP, OTHER
  final String? location;
  final bool isAllDay;

  CalendarEventModel({
    required this.id,
    this.originalId,
    required this.userId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.category = 'OTHER',
    this.location,
    this.isAllDay = false,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] ?? '',
      originalId: json['originalId'],
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : DateTime.now(),
      category: json['category'] ?? 'OTHER',
      location: json['location'],
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'originalId': originalId,
    'userId': userId,
    'title': title,
    'description': description,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'category': category,
    'location': location,
    'isAllDay': isAllDay,
  };
}
