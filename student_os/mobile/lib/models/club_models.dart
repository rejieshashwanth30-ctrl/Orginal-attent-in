enum ClubCategory {
  technical,
  coding,
  robotics,
  cultural,
  sports,
  entrepreneurship,
  literary,
  social,
}

extension ClubCategoryExt on ClubCategory {
  String get displayName {
    switch (this) {
      case ClubCategory.technical:
        return 'Technical';
      case ClubCategory.coding:
        return 'Coding & AI';
      case ClubCategory.robotics:
        return 'Robotics & IoT';
      case ClubCategory.cultural:
        return 'Cultural & Arts';
      case ClubCategory.sports:
        return 'Sports & Fitness';
      case ClubCategory.entrepreneurship:
        return 'E-Cell & Startup';
      case ClubCategory.literary:
        return 'Literary & Debating';
      case ClubCategory.social:
        return 'NSS & Social';
    }
  }
}

class ClubEvent {
  final String id;
  final String clubId;
  final String clubName;
  final String title;
  final DateTime date;
  final String time;
  final String venue;
  final String description;
  final bool isRegistered;
  final int registeredCount;
  final int maxSeats;
  final String category;

  ClubEvent({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.description,
    this.isRegistered = false,
    this.registeredCount = 45,
    this.maxSeats = 100,
    required this.category,
  });

  ClubEvent copyWith({
    bool? isRegistered,
    int? registeredCount,
  }) {
    return ClubEvent(
      id: id,
      clubId: clubId,
      clubName: clubName,
      title: title,
      date: date,
      time: time,
      venue: venue,
      description: description,
      isRegistered: isRegistered ?? this.isRegistered,
      registeredCount: registeredCount ?? this.registeredCount,
      maxSeats: maxSeats,
      category: category,
    );
  }
}

class CampusClub {
  final String id;
  final String name;
  final ClubCategory category;
  final String description;
  final String facultyCoordinator;
  final String studentCoordinator;
  final int memberCount;
  final bool isJoined;
  final List<String> tags;
  final List<ClubEvent> upcomingEvents;
  final List<String> pastEvents;
  final String bannerColor; // Hex representation

  CampusClub({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.facultyCoordinator,
    required this.studentCoordinator,
    required this.memberCount,
    this.isJoined = false,
    required this.tags,
    required this.upcomingEvents,
    required this.pastEvents,
    this.bannerColor = '0xFF6366F1',
  });

  CampusClub copyWith({
    bool? isJoined,
    int? memberCount,
  }) {
    return CampusClub(
      id: id,
      name: name,
      category: category,
      description: description,
      facultyCoordinator: facultyCoordinator,
      studentCoordinator: studentCoordinator,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
      tags: tags,
      upcomingEvents: upcomingEvents,
      pastEvents: pastEvents,
      bannerColor: bannerColor,
    );
  }
}
