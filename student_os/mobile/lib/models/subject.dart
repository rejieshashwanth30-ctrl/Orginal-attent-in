class Subject {
  final String id;
  final String userId;
  final String name;
  final String code;
  final String? faculty;
  final String color;
  final int totalHours;
  final int credits;
  final int totalClasses;
  final int attendedClasses;
  final double percentage;

  Subject({
    required this.id,
    required this.userId,
    required this.name,
    required this.code,
    this.faculty,
    this.color = '#4F46E5',
    this.totalHours = 45,
    this.credits = 3,
    this.totalClasses = 0,
    this.attendedClasses = 0,
    this.percentage = 85.0,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      faculty: json['faculty'],
      color: json['color'] ?? '#4F46E5',
      totalHours: json['totalHours'] is int ? json['totalHours'] : int.tryParse(json['totalHours']?.toString() ?? '45') ?? 45,
      credits: json['credits'] is int ? json['credits'] : int.tryParse(json['credits']?.toString() ?? '3') ?? 3,
      totalClasses: json['totalClasses'] is int ? json['totalClasses'] : 0,
      attendedClasses: json['attendedClasses'] is int ? json['attendedClasses'] : 0,
      percentage: json['percentage'] != null ? (json['percentage'] as num).toDouble() : 85.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'code': code,
      'faculty': faculty,
      'color': color,
      'totalHours': totalHours,
      'credits': credits,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'percentage': percentage,
    };
  }
}
