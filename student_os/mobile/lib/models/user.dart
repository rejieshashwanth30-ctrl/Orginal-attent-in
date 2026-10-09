class User {
  final String id;
  final String email;
  final String role;
  final Profile? profile;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'STUDENT',
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'profile': profile?.toJson(),
    };
  }
}

class Profile {
  final String id;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String college;
  final String department;
  final int year;
  final String rollNumber;
  final double gpa;
  final int careerScore;
  final double studyHoursTotal;
  final String? bio;
  final String? phone;

  Profile({
    required this.id,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.college,
    required this.department,
    required this.year,
    required this.rollNumber,
    this.gpa = 8.5,
    this.careerScore = 72,
    this.studyHoursTotal = 18.5,
    this.bio,
    this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? 'Student',
      avatarUrl: json['avatarUrl'],
      college: json['college'] ?? '',
      department: json['department'] ?? 'CSE',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '3') ?? 3,
      rollNumber: json['rollNumber'] ?? '',
      gpa: (json['gpa'] != null) ? (json['gpa'] as num).toDouble() : 8.5,
      careerScore: json['careerScore'] is int ? json['careerScore'] : 72,
      studyHoursTotal: (json['studyHoursTotal'] != null) ? (json['studyHoursTotal'] as num).toDouble() : 18.5,
      bio: json['bio'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'college': college,
      'department': department,
      'year': year,
      'rollNumber': rollNumber,
      'gpa': gpa,
      'careerScore': careerScore,
      'studyHoursTotal': studyHoursTotal,
      'bio': bio,
      'phone': phone,
    };
  }
}
