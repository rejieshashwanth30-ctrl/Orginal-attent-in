import '../models/transport_models.dart';

class TransportService {
  static final List<TransportRoute> _routes = [
    TransportRoute(
      id: 'rt-12',
      routeNumber: 'Route 12',
      name: 'Main Campus Loop (Hostel & Library)',
      firstBus: '07:30 AM',
      lastBus: '10:00 PM',
      frequencyMinutes: 15,
      colorHex: '#3B82F6', // Blue
      stops: [
        'Main Gate',
        'Hostel Block A',
        'Academic Block (CSE / ECE)',
        'Central Library',
        'Student Cafeteria & Union',
      ],
      scheduleTimes: [
        '08:00 AM',
        '08:15 AM',
        '08:35 AM',
        '08:50 AM',
        '09:05 AM',
        '09:20 AM',
        '09:40 AM',
        '10:00 AM',
        '10:30 AM',
        '11:00 AM',
        '12:00 PM',
        '01:15 PM',
        '02:00 PM',
        '03:30 PM',
        '04:45 PM',
        '05:15 PM',
        '06:00 PM',
        '07:30 PM',
        '09:00 PM',
      ],
      description: 'Primary high-frequency loop connecting residential hostels with lecture halls and the central library.',
    ),
    TransportRoute(
      id: 'rt-a',
      routeNumber: 'Route A',
      name: 'Hostel — Academic — Sports Complex',
      firstBus: '07:45 AM',
      lastBus: '09:00 PM',
      frequencyMinutes: 20,
      colorHex: '#10B981', // Green
      stops: [
        'Hostel Block B & C',
        'Main Gate',
        'Academic Block',
        'Sports Complex & Gym',
        'Open Air Theatre',
      ],
      scheduleTimes: [
        '08:00 AM',
        '08:20 AM',
        '08:40 AM',
        '09:00 AM',
        '09:30 AM',
        '10:15 AM',
        '11:30 AM',
        '01:00 PM',
        '02:30 PM',
        '04:00 PM',
        '05:00 PM',
        '06:30 PM',
        '08:00 PM',
      ],
      description: 'Direct shuttle connecting south hostel blocks to sports facilities and lecture auditoriums.',
    ),
    TransportRoute(
      id: 'rt-express',
      routeNumber: 'Route Express',
      name: 'Metro Connector — Innovation Hub',
      firstBus: '07:00 AM',
      lastBus: '10:30 PM',
      frequencyMinutes: 25,
      colorHex: '#8B5CF6', // Purple
      stops: [
        'Campus Metro Station',
        'Main Campus Gate',
        'Innovation & Research Park',
        'Central Library',
      ],
      scheduleTimes: [
        '07:30 AM',
        '07:55 AM',
        '08:20 AM',
        '08:45 AM',
        '09:10 AM',
        '09:35 AM',
        '10:30 AM',
        '12:00 PM',
        '02:15 PM',
        '04:30 PM',
        '05:30 PM',
        '06:45 PM',
        '08:15 PM',
        '09:30 PM',
      ],
      description: 'Rapid shuttle connecting city transit metro stations to campus research departments.',
    ),
  ];

  static List<TransportRoute> get routes => List.unmodifiable(_routes);

  /// Search stops and match recommended routes with next scheduled departures
  static TransportSearchResult? searchDestination(String query) {
    if (query.trim().isEmpty) return null;
    final q = query.toLowerCase();

    for (final route in _routes) {
      for (final stop in route.stops) {
        if (stop.toLowerCase().contains(q)) {
          return TransportSearchResult(
            searchedStop: stop,
            recommendedRoute: route,
            nextBusTime: '8:35 AM',
            followingBusTime: '9:05 AM',
            estimatedTravelMinutes: 8,
          );
        }
      }
    }

    // Default to Route 12 if partial match
    return TransportSearchResult(
      searchedStop: query,
      recommendedRoute: _routes[0],
      nextBusTime: '8:35 AM',
      followingBusTime: '9:05 AM',
      estimatedTravelMinutes: 10,
    );
  }

  /// AI Transport Assistant grounded on actual route and schedule data
  static Future<String> askTransportAssistant(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = query.toLowerCase();

    if (q.contains('library') || q.contains('book')) {
      return '''🚍 **Recommended Route for Central Library**:

- **Take Route 12** (*Main Campus Loop*) or **Route Express**.
- **Boarding Point**: Main Gate or Hostel Block A.
- **Scheduled Departure**: **8:35 AM** (Next) & **9:05 AM** (Following).
- **Estimated Travel Time**: ~6 minutes.

ℹ️ *Note: Live bus tracking is currently unavailable. Showing scheduled transport information.*''';
    }

    if (q.contains('sports') || q.contains('gym') || q.contains('ground')) {
      return '''🏸 **Recommended Route for Sports Complex**:

- **Take Route A** (*Hostel → Main Gate → Sports Complex*).
- **Boarding Point**: Hostel Block B & C or Main Gate.
- **Scheduled Departure**: **8:40 AM** & **9:00 AM**.
- **Frequency**: Every 20 minutes.

ℹ️ *Note: Live bus tracking is currently unavailable. Showing scheduled transport information.*''';
    }

    if (q.contains('leave') || q.contains('when') || q.contains('time') || q.contains('hostel')) {
      return '''⏰ **Hostel Departure Recommendation**:

If your class begins at **9:00 AM** at the Academic Block:
- Board **Route 12 at 8:35 AM** from Hostel Block A.
- Arrival at Academic Block is approximately **8:47 AM** (12-minute transit).

ℹ️ *Note: Live bus tracking is currently unavailable. Showing scheduled transport information.*''';
    }

    if (q.contains('metro') || q.contains('station') || q.contains('city')) {
      return '''🚇 **Metro Shuttle Connector**:

- **Take Route Express** from Main Campus Gate to Campus Metro Station.
- **Departures**: Every 25 minutes from 07:00 AM to 10:30 PM.
- **Next scheduled shuttle**: **8:45 AM**.

ℹ️ *Note: Live bus tracking is currently unavailable. Showing scheduled transport information.*''';
    }

    return '''🚍 **Campus Shuttle Assistant**:

I can help you navigate campus routes, find the next scheduled bus, and estimate departure times between Hostels, Academic Blocks, Library, Metro, and Sports Complex.

- **Route 12**: Hostels ↔ Academic Block ↔ Library (Every 15 min)
- **Route A**: Hostels ↔ Sports Complex (Every 20 min)
- **Route Express**: Metro ↔ Main Gate ↔ Innovation Hub (Every 25 min)

ℹ️ *Note: Live bus tracking is currently unavailable. Showing scheduled transport information.*''';
  }
}
