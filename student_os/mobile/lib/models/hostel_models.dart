class Roommate {
  final String id;
  final String name;
  final String department;
  final int year;
  final String rollNumber;
  final String phone;
  final String? avatarUrl;
  final String roomBed;

  Roommate({
    required this.id,
    required this.name,
    required this.department,
    required this.year,
    required this.rollNumber,
    required this.phone,
    this.avatarUrl,
    required this.roomBed,
  });

  factory Roommate.fromJson(Map<String, dynamic> json) {
    return Roommate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      year: json['year'] is int ? json['year'] : 3,
      rollNumber: json['rollNumber'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'],
      roomBed: json['roomBed'] ?? 'Bed A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'year': year,
      'rollNumber': rollNumber,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'roomBed': roomBed,
    };
  }
}

class HostelRoom {
  final String roomNumber;
  final String block;
  final String floor;
  final String roomType; // e.g. "4 Sharing", "2 Sharing", "Single AC"
  final int sharingCapacity;
  final int currentOccupancy;
  final List<String> amenities;
  final List<Roommate> roommates;

  HostelRoom({
    required this.roomNumber,
    required this.block,
    required this.floor,
    required this.roomType,
    required this.sharingCapacity,
    required this.currentOccupancy,
    required this.amenities,
    required this.roommates,
  });

  factory HostelRoom.fromJson(Map<String, dynamic> json) {
    return HostelRoom(
      roomNumber: json['roomNumber'] ?? '204',
      block: json['block'] ?? 'Block A',
      floor: json['floor'] ?? '2nd Floor',
      roomType: json['roomType'] ?? '4 Sharing',
      sharingCapacity: json['sharingCapacity'] is int ? json['sharingCapacity'] : 4,
      currentOccupancy: json['currentOccupancy'] is int ? json['currentOccupancy'] : 4,
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      roommates: (json['roommates'] as List<dynamic>?)?.map((e) => Roommate.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNumber': roomNumber,
      'block': block,
      'floor': floor,
      'roomType': roomType,
      'sharingCapacity': sharingCapacity,
      'currentOccupancy': currentOccupancy,
      'amenities': amenities,
      'roommates': roommates.map((r) => r.toJson()).toList(),
    };
  }
}

class MessMenu {
  final String dayOfWeek;
  final String breakfast;
  final String lunch;
  final String snacks;
  final String dinner;
  final String? specialNote;
  final bool isSpecialDay;

  MessMenu({
    required this.dayOfWeek,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
    this.specialNote,
    this.isSpecialDay = false,
  });

  factory MessMenu.fromJson(Map<String, dynamic> json) {
    return MessMenu(
      dayOfWeek: json['dayOfWeek'] ?? 'Monday',
      breakfast: json['breakfast'] ?? '',
      lunch: json['lunch'] ?? '',
      snacks: json['snacks'] ?? '',
      dinner: json['dinner'] ?? '',
      specialNote: json['specialNote'],
      isSpecialDay: json['isSpecialDay'] ?? false,
    );
  }

  MessMenu copyWith({
    String? dayOfWeek,
    String? breakfast,
    String? lunch,
    String? snacks,
    String? dinner,
    String? specialNote,
    bool? isSpecialDay,
  }) {
    return MessMenu(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      snacks: snacks ?? this.snacks,
      dinner: dinner ?? this.dinner,
      specialNote: specialNote ?? this.specialNote,
      isSpecialDay: isSpecialDay ?? this.isSpecialDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'breakfast': breakfast,
      'lunch': lunch,
      'snacks': snacks,
      'dinner': dinner,
      'specialNote': specialNote,
      'isSpecialDay': isSpecialDay,
    };
  }
}

enum ComplaintCategory {
  room,
  electrical,
  plumbing,
  cleaning,
  wifi,
  furniture,
  other,
}

extension ComplaintCategoryExt on ComplaintCategory {
  String get displayName {
    switch (this) {
      case ComplaintCategory.room:
        return 'Room';
      case ComplaintCategory.electrical:
        return 'Electrical';
      case ComplaintCategory.plumbing:
        return 'Plumbing';
      case ComplaintCategory.cleaning:
        return 'Cleaning';
      case ComplaintCategory.wifi:
        return 'Wi-Fi';
      case ComplaintCategory.furniture:
        return 'Furniture';
      case ComplaintCategory.other:
        return 'Other';
    }
  }

  static ComplaintCategory fromString(String val) {
    switch (val.toLowerCase()) {
      case 'room':
        return ComplaintCategory.room;
      case 'electrical':
        return ComplaintCategory.electrical;
      case 'plumbing':
        return ComplaintCategory.plumbing;
      case 'cleaning':
        return ComplaintCategory.cleaning;
      case 'wi-fi':
      case 'wifi':
        return ComplaintCategory.wifi;
      case 'furniture':
        return ComplaintCategory.furniture;
      default:
        return ComplaintCategory.other;
    }
  }
}

enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

extension ComplaintStatusExt on ComplaintStatus {
  String get displayName {
    switch (this) {
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.rejected:
        return 'Rejected';
    }
  }

  static ComplaintStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'in_progress':
      case 'in progress':
        return ComplaintStatus.inProgress;
      case 'resolved':
        return ComplaintStatus.resolved;
      case 'rejected':
        return ComplaintStatus.rejected;
      default:
        return ComplaintStatus.pending;
    }
  }
}

class HostelComplaint {
  final String id;
  final String title;
  final String description;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final String roomNumber;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? adminRemarks;

  HostelComplaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.roomNumber,
    required this.createdAt,
    this.resolvedAt,
    this.adminRemarks,
  });

  factory HostelComplaint.fromJson(Map<String, dynamic> json) {
    return HostelComplaint(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: ComplaintCategoryExt.fromString(json['category'] ?? 'other'),
      status: ComplaintStatusExt.fromString(json['status'] ?? 'pending'),
      roomNumber: json['roomNumber'] ?? '204',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      adminRemarks: json['adminRemarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.displayName,
      'status': status.displayName,
      'roomNumber': roomNumber,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'adminRemarks': adminRemarks,
    };
  }
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

extension LeaveStatusExt on LeaveStatus {
  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
    }
  }

  static LeaveStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'approved':
        return LeaveStatus.approved;
      case 'rejected':
        return LeaveStatus.rejected;
      default:
        return LeaveStatus.pending;
    }
  }
}

class HostelLeaveRequest {
  final String id;
  final String leaveType; // "Home Visit", "Medical Leave", "Weekend Outing", "Academic Event"
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String emergencyContact;
  final LeaveStatus status;
  final DateTime appliedAt;
  final String? approvedBy;
  final String? remarks;

  HostelLeaveRequest({
    required this.id,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.emergencyContact,
    required this.status,
    required this.appliedAt,
    this.approvedBy,
    this.remarks,
  });

  factory HostelLeaveRequest.fromJson(Map<String, dynamic> json) {
    return HostelLeaveRequest(
      id: json['id'] ?? '',
      leaveType: json['leaveType'] ?? 'Home Visit',
      fromDate: json['fromDate'] != null ? DateTime.parse(json['fromDate']) : DateTime.now(),
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : DateTime.now().add(const Duration(days: 2)),
      reason: json['reason'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      status: LeaveStatusExt.fromString(json['status'] ?? 'pending'),
      appliedAt: json['appliedAt'] != null ? DateTime.parse(json['appliedAt']) : DateTime.now(),
      approvedBy: json['approvedBy'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leaveType': leaveType,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'reason': reason,
      'emergencyContact': emergencyContact,
      'status': status.displayName,
      'appliedAt': appliedAt.toIso8601String(),
      'approvedBy': approvedBy,
      'remarks': remarks,
    };
  }
}

class HostelNotice {
  final String id;
  final String title;
  final String content;
  final String category; // "INSPECTION", "MESS", "MAINTENANCE", "GENERAL", "EVENT"
  final DateTime date;
  final bool isPinned;

  HostelNotice({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isPinned = false,
  });

  factory HostelNotice.fromJson(Map<String, dynamic> json) {
    return HostelNotice(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'GENERAL',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      isPinned: json['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
      'isPinned': isPinned,
    };
  }
}

class HostelFee {
  final double totalFee;
  final double paidAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final String semester;
  final String status; // "PAID", "PARTIAL", "DUE"
  final List<Map<String, dynamic>> breakdown;

  HostelFee({
    required this.totalFee,
    required this.paidAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.semester,
    required this.status,
    required this.breakdown,
  });

  factory HostelFee.fromJson(Map<String, dynamic> json) {
    return HostelFee(
      totalFee: (json['totalFee'] as num?)?.toDouble() ?? 45000.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 45000.0,
      pendingAmount: (json['pendingAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now().add(const Duration(days: 30)),
      semester: json['semester'] ?? 'Semester V (2026)',
      status: json['status'] ?? 'PAID',
      breakdown: (json['breakdown'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFee': totalFee,
      'paidAmount': paidAmount,
      'pendingAmount': pendingAmount,
      'dueDate': dueDate.toIso8601String(),
      'semester': semester,
      'status': status,
      'breakdown': breakdown,
    };
  }
}

class HostelEmergencyContact {
  final String role;
  final String name;
  final String phoneNumber;
  final String availability;
  final String location;

  HostelEmergencyContact({
    required this.role,
    required this.name,
    required this.phoneNumber,
    required this.availability,
    required this.location,
  });
}
