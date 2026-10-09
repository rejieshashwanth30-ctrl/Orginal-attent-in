class AttendanceRecord {
  final String id;
  final String userId;
  final String subjectId;
  final DateTime date;
  final String status; // PRESENT, ABSENT, CANCELLED
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.date,
    required this.status,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subjectId: json['subjectId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'PRESENT',
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subjectId': subjectId,
      'date': date.toIso8601String(),
      'status': status,
      'remarks': remarks,
    };
  }
}

class SubjectAttendance {
  final String subjectId;
  final String subjectName;
  final String subjectCode;
  final String? faculty;
  final String color;
  final int totalClasses;
  final int attendedClasses;
  final int missedClasses;
  final double percentage;
  final bool isLow;
  final int classesNeeded;
  final int classesCanMiss;
  final List<AttendanceRecord> recentRecords;

  SubjectAttendance({
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    this.faculty,
    required this.color,
    required this.totalClasses,
    required this.attendedClasses,
    required this.missedClasses,
    required this.percentage,
    required this.isLow,
    required this.classesNeeded,
    required this.classesCanMiss,
    this.recentRecords = const [],
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    var recList = <AttendanceRecord>[];
    if (json['recentRecords'] != null && json['recentRecords'] is List) {
      recList = (json['recentRecords'] as List)
          .map((r) => AttendanceRecord.fromJson(r))
          .toList();
    }

    return SubjectAttendance(
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      faculty: json['faculty'],
      color: json['color'] ?? '#4F46E5',
      totalClasses: json['totalClasses'] is int ? json['totalClasses'] : 0,
      attendedClasses: json['attendedClasses'] is int ? json['attendedClasses'] : 0,
      missedClasses: json['missedClasses'] is int ? json['missedClasses'] : 0,
      percentage: (json['percentage'] != null) ? (json['percentage'] as num).toDouble() : 85.0,
      isLow: json['isLow'] ?? false,
      classesNeeded: json['classesNeeded'] is int ? json['classesNeeded'] : 0,
      classesCanMiss: json['classesCanMiss'] is int ? json['classesCanMiss'] : 0,
      recentRecords: recList,
    );
  }
}

class OverallAttendanceSummary {
  final double overallPercentage;
  final int totalClasses;
  final int attendedClasses;
  final int missedClasses;
  final int overallNeeded;
  final int overallCanMiss;
  final List<SubjectAttendance> subjects;

  OverallAttendanceSummary({
    required this.overallPercentage,
    required this.totalClasses,
    required this.attendedClasses,
    required this.missedClasses,
    required this.overallNeeded,
    required this.overallCanMiss,
    required this.subjects,
  });

  factory OverallAttendanceSummary.fromJson(Map<String, dynamic> json) {
    var subs = <SubjectAttendance>[];
    if (json['subjects'] != null && json['subjects'] is List) {
      subs = (json['subjects'] as List)
          .map((s) => SubjectAttendance.fromJson(s))
          .toList();
    }

    return OverallAttendanceSummary(
      overallPercentage: (json['overallPercentage'] != null)
          ? (json['overallPercentage'] as num).toDouble()
          : 87.5,
      totalClasses: json['totalClasses'] is int ? json['totalClasses'] : 0,
      attendedClasses: json['attendedClasses'] is int ? json['attendedClasses'] : 0,
      missedClasses: json['missedClasses'] is int ? json['missedClasses'] : 0,
      overallNeeded: json['overallNeeded'] is int ? json['overallNeeded'] : 0,
      overallCanMiss: json['overallCanMiss'] is int ? json['overallCanMiss'] : 0,
      subjects: subs,
    );
  }
}
