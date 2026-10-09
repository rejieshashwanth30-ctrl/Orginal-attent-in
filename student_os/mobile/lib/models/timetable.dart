class TimetableSlot {
  final String id;
  final String subjectId;
  final String subjectName;
  final String subjectCode;
  final String room;
  final String? faculty;
  final String startTime;
  final String endTime;
  final String color;

  TimetableSlot({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.room,
    this.faculty,
    required this.startTime,
    required this.endTime,
    this.color = '#4F46E5',
  });

  factory TimetableSlot.fromJson(Map<String, dynamic> json) {
    return TimetableSlot(
      id: json['id'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      room: json['room'] ?? '',
      faculty: json['faculty'],
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      color: json['color'] ?? '#4F46E5',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'subjectCode': subjectCode,
      'room': room,
      'faculty': faculty,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
    };
  }
}
