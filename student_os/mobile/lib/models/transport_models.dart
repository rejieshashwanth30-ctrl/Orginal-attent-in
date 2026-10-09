class TransportStop {
  final String id;
  final String name;
  final String landmark;
  final int orderIndex;

  TransportStop({
    required this.id,
    required this.name,
    required this.landmark,
    required this.orderIndex,
  });

  factory TransportStop.fromJson(Map<String, dynamic> json) {
    return TransportStop(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      landmark: json['landmark'] ?? '',
      orderIndex: json['orderIndex'] is int ? json['orderIndex'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'landmark': landmark,
      'orderIndex': orderIndex,
    };
  }
}

class TransportRoute {
  final String id;
  final String routeNumber;
  final String name;
  final String firstBus;
  final String lastBus;
  final int frequencyMinutes;
  final List<String> stops;
  final List<String> scheduleTimes;
  final String colorHex;
  final String description;

  TransportRoute({
    required this.id,
    required this.routeNumber,
    required this.name,
    required this.firstBus,
    required this.lastBus,
    required this.frequencyMinutes,
    required this.stops,
    required this.scheduleTimes,
    this.colorHex = '#3B82F6',
    this.description = '',
  });

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      id: json['id'] ?? '',
      routeNumber: json['routeNumber'] ?? '',
      name: json['name'] ?? '',
      firstBus: json['firstBus'] ?? '07:30 AM',
      lastBus: json['lastBus'] ?? '09:30 PM',
      frequencyMinutes: json['frequencyMinutes'] is int ? json['frequencyMinutes'] : 20,
      stops: (json['stops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      scheduleTimes: (json['scheduleTimes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      colorHex: json['colorHex'] ?? '#3B82F6',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeNumber': routeNumber,
      'name': name,
      'firstBus': firstBus,
      'lastBus': lastBus,
      'frequencyMinutes': frequencyMinutes,
      'stops': stops,
      'scheduleTimes': scheduleTimes,
      'colorHex': colorHex,
      'description': description,
    };
  }

  String get stopsDisplay => stops.join(' → ');
}

class TransportSearchResult {
  final String searchedStop;
  final TransportRoute recommendedRoute;
  final String nextBusTime;
  final String followingBusTime;
  final int estimatedTravelMinutes;

  TransportSearchResult({
    required this.searchedStop,
    required this.recommendedRoute,
    required this.nextBusTime,
    required this.followingBusTime,
    required this.estimatedTravelMinutes,
  });
}
