import 'package:flutter/material.dart';
import '../models/club_models.dart';

class ClubProvider extends ChangeNotifier {
  List<CampusClub> _clubs = [];
  ClubCategory? _selectedCategory;

  ClubProvider() {
    _initMockData();
  }

  List<CampusClub> get clubs => _clubs;
  ClubCategory? get selectedCategory => _selectedCategory;

  List<CampusClub> get filteredClubs {
    if (_selectedCategory == null) return _clubs;
    return _clubs.where((c) => c.category == _selectedCategory).toList();
  }

  List<ClubEvent> get allUpcomingEvents {
    final list = <ClubEvent>[];
    for (final c in _clubs) {
      list.addAll(c.upcomingEvents);
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  void setSelectedCategory(ClubCategory? cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void toggleJoinClub(String clubId) {
    final idx = _clubs.indexWhere((c) => c.id == clubId);
    if (idx != -1) {
      final club = _clubs[idx];
      final newJoined = !club.isJoined;
      _clubs[idx] = club.copyWith(
        isJoined: newJoined,
        memberCount: newJoined ? club.memberCount + 1 : club.memberCount - 1,
      );
      notifyListeners();
    }
  }

  void toggleRegisterEvent(String eventId) {
    for (int i = 0; i < _clubs.length; i++) {
      final club = _clubs[i];
      final evIdx = club.upcomingEvents.indexWhere((e) => e.id == eventId);
      if (evIdx != -1) {
        final ev = club.upcomingEvents[evIdx];
        final updatedEv = ev.copyWith(
          isRegistered: !ev.isRegistered,
          registeredCount: !ev.isRegistered ? ev.registeredCount + 1 : ev.registeredCount - 1,
        );
        final updatedList = List<ClubEvent>.from(club.upcomingEvents);
        updatedList[evIdx] = updatedEv;

        _clubs[i] = CampusClub(
          id: club.id,
          name: club.name,
          category: club.category,
          description: club.description,
          facultyCoordinator: club.facultyCoordinator,
          studentCoordinator: club.studentCoordinator,
          memberCount: club.memberCount,
          isJoined: club.isJoined,
          tags: club.tags,
          upcomingEvents: updatedList,
          pastEvents: club.pastEvents,
          bannerColor: club.bannerColor,
        );
        notifyListeners();
        break;
      }
    }
  }

  void _initMockData() {
    _clubs = [
      CampusClub(
        id: 'cl-1',
        name: 'AI & Machine Learning Club (NeuroNet)',
        category: ClubCategory.coding,
        description: 'Pioneering research in GenAI, Computer Vision, Reinforcement Learning, and Kaggle Grandmaster tracks.',
        facultyCoordinator: 'Dr. Ramesh Sundaram (CSE)',
        studentCoordinator: 'Rohan Varma (Final Year AI)',
        memberCount: 240,
        isJoined: true,
        bannerColor: '0xFF6366F1',
        tags: ['PyTorch', 'LLMs', 'Kaggle', 'Computer Vision'],
        upcomingEvents: [
          ClubEvent(
            id: 'ev-1',
            clubId: 'cl-1',
            clubName: 'AI/ML Club',
            title: 'LLM Fine-Tuning & Agentic RAG Masterclass',
            date: DateTime.now().add(const Duration(days: 3)),
            time: '4:30 PM – 6:30 PM',
            venue: 'Turing Auditorium, Lab 4',
            description: 'Hands-on live deployment of LoRA models on local GPU clusters with LangChain.',
            category: 'Workshop',
            isRegistered: true,
            registeredCount: 88,
            maxSeats: 120,
          ),
          ClubEvent(
            id: 'ev-2',
            clubId: 'cl-1',
            clubName: 'AI/ML Club',
            title: 'Kaggle Campus Cup: Vision Benchmark',
            date: DateTime.now().add(const Duration(days: 10)),
            time: '9:00 AM – 5:00 PM',
            venue: 'Central Computing Centre',
            description: '24-hour Kaggle sprint to build the highest F1-score medical imaging classifier.',
            category: 'Hackathon',
            isRegistered: false,
            registeredCount: 54,
            maxSeats: 100,
          ),
        ],
        pastEvents: ['CVPR 2025 Paper Reading Series', 'Intro to Diffusion Models Workshop'],
      ),
      CampusClub(
        id: 'cl-2',
        name: 'Competitive Coding Club (CodeX)',
        category: ClubCategory.coding,
        description: 'Elite DSA problem solving, ICPC training camps, Codeforces division sprints, and interview prep.',
        facultyCoordinator: 'Prof. K. Venkatesh',
        studentCoordinator: 'Aditi Nair (3rd Year CSE)',
        memberCount: 310,
        isJoined: true,
        bannerColor: '0xFF06B6D4',
        tags: ['DSA', 'LeetCode', 'ICPC', 'Graphs', 'DP'],
        upcomingEvents: [
          ClubEvent(
            id: 'ev-3',
            clubId: 'cl-2',
            clubName: 'CodeX',
            title: 'Bi-Weekly Codeforces Division 2 Simulation',
            date: DateTime.now().add(const Duration(days: 5)),
            time: '6:00 PM – 8:30 PM',
            venue: 'Online & Lab 2',
            description: 'Timed contest with live editorial analysis by ICPC regionalists.',
            category: 'Contest',
            isRegistered: false,
            registeredCount: 112,
            maxSeats: 200,
          ),
        ],
        pastEvents: ['Graph Theory BootCamp', 'Dynamic Programming Demystified'],
      ),
      CampusClub(
        id: 'cl-3',
        name: 'Robotics & Autonomous Systems (RoboTech)',
        category: ClubCategory.robotics,
        description: 'Building autonomous rovers, drones, ROS2 robots, and embedded IoT edge nodes.',
        facultyCoordinator: 'Dr. S. Mukherjee (ECE)',
        studentCoordinator: 'Karthik Rao (4th Year Mechatronics)',
        memberCount: 160,
        isJoined: false,
        bannerColor: '0xFFF59E0B',
        tags: ['ROS2', 'Arduino', 'Drones', 'Edge AI', 'Sensors'],
        upcomingEvents: [
          ClubEvent(
            id: 'ev-4',
            clubId: 'cl-3',
            clubName: 'RoboTech',
            title: 'Line Follower & Obstacle Bot Racing',
            date: DateTime.now().add(const Duration(days: 7)),
            time: '2:00 PM – 5:00 PM',
            venue: 'Indoor Sports Arena Quad',
            description: 'Championship track racing with PID tuned micro-controllers.',
            category: 'Competition',
            isRegistered: false,
            registeredCount: 32,
            maxSeats: 60,
          ),
        ],
        pastEvents: ['ESP32 IoT Workshop', 'QuadCopter Flight Dynamics Lab'],
      ),
      CampusClub(
        id: 'cl-4',
        name: 'Entrepreneurship & Innovation Cell (E-Cell)',
        category: ClubCategory.entrepreneurship,
        description: 'Fostering student startup founders, venture pitches, angel investor connections, and product incubators.',
        facultyCoordinator: 'Prof. Ananya Sen',
        studentCoordinator: 'Tanmay Mehta (MBA/B.Tech Tech Management)',
        memberCount: 190,
        isJoined: false,
        bannerColor: '0xFF10B981',
        tags: ['Startups', 'Pitch Deck', 'Product Management', 'Venture Capital'],
        upcomingEvents: [
          ClubEvent(
            id: 'ev-5',
            clubId: 'cl-4',
            clubName: 'E-Cell',
            title: 'Campus Shark Tank — Angel Pitch Session',
            date: DateTime.now().add(const Duration(days: 12)),
            time: '10:00 AM – 2:00 PM',
            venue: 'Management Seminar Hall',
            description: 'Top 10 student startups pitch for a pool of ₹5,00,000 seed grant.',
            category: 'Pitch',
            isRegistered: false,
            registeredCount: 75,
            maxSeats: 150,
          ),
        ],
        pastEvents: ['Product Management 101', 'Startup Legal & IP Workshop'],
      ),
      CampusClub(
        id: 'cl-5',
        name: 'Cultural & Music Society (Symphony)',
        category: ClubCategory.cultural,
        description: 'Vocal music, acoustic bands, contemporary dance, theatre, and annual cultural fest organizing.',
        facultyCoordinator: 'Dr. Priya Balan',
        studentCoordinator: 'Sahil Khanna',
        memberCount: 280,
        isJoined: false,
        bannerColor: '0xFFEC4899',
        tags: ['Music', 'Acoustic', 'Dance', 'Stage', 'Arts'],
        upcomingEvents: [
          ClubEvent(
            id: 'ev-6',
            clubId: 'cl-5',
            clubName: 'Symphony',
            title: 'Acoustic Sunset Unplugged Jam',
            date: DateTime.now().add(const Duration(days: 4)),
            time: '5:30 PM – 7:30 PM',
            venue: 'Open Air Amphitheatre',
            description: 'Live musical performances under the evening sky. Open mic slots available.',
            category: 'Concert',
            isRegistered: false,
            registeredCount: 140,
            maxSeats: 300,
          ),
        ],
        pastEvents: ['Battle of the Bands 2025', 'Classical Raga Evening'],
      ),
    ];
  }
}
