import 'package:flutter/material.dart';
import '../models/hostel_models.dart';

class HostelProvider extends ChangeNotifier {
  final bool _isLoading = false;
  String? _error;

  // 1. Room Data
  late HostelRoom _room;

  // 2. Attendance
  bool _isTodayPresent = true;
  final double _monthlyAttendancePercentage = 96.2;
  final String _lastRollCallTime = '09:30 PM';
  final String _curfewTime = '10:00 PM';

  // 3. Mess Menu (Weekly Schedule)
  List<MessMenu> _weeklyMessMenu = [];

  // 4. Complaints
  List<HostelComplaint> _complaints = [];

  // 5. Leave Requests
  List<HostelLeaveRequest> _leaveRequests = [];

  // 6. Notices
  List<HostelNotice> _notices = [];

  // 7. Hostel Fees
  late HostelFee _hostelFee;

  // 8. Emergency Contacts
  List<HostelEmergencyContact> _emergencyContacts = [];

  HostelProvider() {
    _initMockData();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  HostelRoom get room => _room;
  bool get isTodayPresent => _isTodayPresent;
  double get monthlyAttendancePercentage => _monthlyAttendancePercentage;
  String get lastRollCallTime => _lastRollCallTime;
  String get curfewTime => _curfewTime;
  List<MessMenu> get weeklyMessMenu => _weeklyMessMenu;
  List<HostelComplaint> get complaints => _complaints;
  List<HostelLeaveRequest> get leaveRequests => _leaveRequests;
  List<HostelNotice> get notices => _notices;
  HostelFee get hostelFee => _hostelFee;
  List<HostelEmergencyContact> get emergencyContacts => _emergencyContacts;

  MessMenu get todayMessMenu {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final currentDayName = days[now.weekday - 1];
    return _weeklyMessMenu.firstWhere(
      (m) => m.dayOfWeek.toLowerCase() == currentDayName.toLowerCase(),
      orElse: () => _weeklyMessMenu.first,
    );
  }

  int get pendingComplaintsCount =>
      _complaints.where((c) => c.status == ComplaintStatus.pending || c.status == ComplaintStatus.inProgress).length;

  int get pendingLeaveCount =>
      _leaveRequests.where((l) => l.status == LeaveStatus.pending).length;

  void _initMockData() {
    // Roommates
    final roommates = [
      Roommate(
        id: 'rm-1',
        name: 'Aarav Sharma (You)',
        department: 'CSE',
        year: 3,
        rollNumber: '21BCSE088',
        phone: '+91 98765 43210',
        roomBed: 'Bed A (Window Side)',
      ),
      Roommate(
        id: 'rm-2',
        name: 'Rohan Verma',
        department: 'ECE',
        year: 3,
        rollNumber: '21BECE042',
        phone: '+91 98111 22334',
        roomBed: 'Bed B',
      ),
      Roommate(
        id: 'rm-3',
        name: 'Karthik Raja',
        department: 'AIML',
        year: 3,
        rollNumber: '21BAIM019',
        phone: '+91 97222 33445',
        roomBed: 'Bed C',
      ),
      Roommate(
        id: 'rm-4',
        name: 'Devendra Patel',
        department: 'IT',
        year: 3,
        rollNumber: '21BIT055',
        phone: '+91 96333 44556',
        roomBed: 'Bed D',
      ),
    ];

    // Room
    _room = HostelRoom(
      roomNumber: '204',
      block: 'Block A (Aryabhata)',
      floor: '2nd Floor',
      roomType: '4 Sharing Deluxe',
      sharingCapacity: 4,
      currentOccupancy: 4,
      amenities: [
        'High-Speed Wi-Fi (100 Mbps)',
        'Attached Balcony',
        'Study Desks & Ergonomic Chairs',
        'Ceiling Fans & LED Lights',
        'Individual Steel Wardrobes',
        'Water Cooler on Floor',
        'Solar Water Heater',
      ],
      roommates: roommates,
    );

    // Weekly Mess Menu
    _weeklyMessMenu = [
      MessMenu(
        dayOfWeek: 'Monday',
        breakfast: 'Idli + Sambar + Coconut Chutney & Tea/Coffee',
        lunch: 'Steamed Rice + Dal Tadka + Aloo Gobi + Curd',
        snacks: 'Samosa / Poha + Masala Chai',
        dinner: 'Phulka Chapati + Paneer Butter Masala + Jeera Rice',
      ),
      MessMenu(
        dayOfWeek: 'Tuesday',
        breakfast: 'Aloo Paratha + Curd + Pickle & Fresh Milk',
        lunch: 'Veg Biryani / Chicken Curry + Raita + Papad',
        snacks: 'Veg Cutlet + Tea',
        dinner: 'Roti + Mixed Veg Curry + Dal Fry + Gulab Jamun',
      ),
      MessMenu(
        dayOfWeek: 'Wednesday',
        breakfast: 'Medu Vada + Pongal + Sambar & Coffee',
        lunch: 'Rice + Rajma Masala + Bhindi Fry + Salad',
        snacks: 'Biscuits + Filter Coffee',
        dinner: 'Butter Naan + Shahi Paneer + Dal Makhani',
        isSpecialDay: true,
        specialNote: 'Special Dinner: Ice Cream & Sweet Corn Soup',
      ),
      MessMenu(
        dayOfWeek: 'Thursday',
        breakfast: 'Masala Dosa + Tomato Chutney + Milk',
        lunch: 'Lemon Rice + Curd Rice + Potato Roast + Pickle',
        snacks: 'Bread Pakora + Tea',
        dinner: 'Chapati + Kadai Paneer / Egg Curry + Rice',
      ),
      MessMenu(
        dayOfWeek: 'Friday',
        breakfast: 'Puri + Aloo Bhaji + Kesari & Tea',
        lunch: 'Hyderabadi Dum Biryani (Veg/Chicken) + Mirchi Ka Salan',
        snacks: 'Banana / Fruit Salad + Green Tea',
        dinner: 'Roti + Dal Palak + Matar Mushroom + Kheer',
        isSpecialDay: true,
      ),
      MessMenu(
        dayOfWeek: 'Saturday',
        breakfast: 'Uttapam + Sambhar + Mint Chutney & Coffee',
        lunch: 'Fried Rice + Veg Manchurian + Sweet Corn Soup',
        snacks: 'Bhel Puri + Chai',
        dinner: 'Phulka + Paneer Tikka Masala + Jeera Pulao',
      ),
      MessMenu(
        dayOfWeek: 'Sunday',
        breakfast: 'Chole Bhature + Lassi / Milk',
        lunch: 'Special South Indian Feast (Rice, Sambar, Rasam, Payasam, Appalam)',
        snacks: 'Cookies + Masala Tea',
        dinner: 'Tandoori Roti + Malai Kofta + Gajar Ka Halwa',
        isSpecialDay: true,
        specialNote: 'Sunday Feast Night',
      ),
    ];

    // Complaints
    _complaints = [
      HostelComplaint(
        id: 'comp-1',
        title: 'Wi-Fi Signal Drop in Room 204',
        description: 'Wi-Fi router on the 2nd floor wing has low bandwidth and frequent disconnections during evening peak hours.',
        category: ComplaintCategory.wifi,
        status: ComplaintStatus.inProgress,
        roomNumber: '204',
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        adminRemarks: 'Technician assigned. Router firmware upgrade scheduled today at 4:00 PM.',
      ),
      HostelComplaint(
        id: 'comp-2',
        title: 'Ceiling Fan Regulator Humming',
        description: 'The ceiling fan speed regulator makes a buzzing noise when set to step 3.',
        category: ComplaintCategory.electrical,
        status: ComplaintStatus.resolved,
        roomNumber: '204',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
        adminRemarks: 'Regulator capacitor replaced by maintenance team.',
      ),
      HostelComplaint(
        id: 'comp-3',
        title: 'Bathroom Tap Slow Water Leak',
        description: 'Washbasin cold tap in room 204 attached washroom drips slowly.',
        category: ComplaintCategory.plumbing,
        status: ComplaintStatus.pending,
        roomNumber: '204',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    // Leave Requests
    _leaveRequests = [
      HostelLeaveRequest(
        id: 'lev-1',
        leaveType: 'Home Visit',
        fromDate: DateTime.now().add(const Duration(days: 2)),
        toDate: DateTime.now().add(const Duration(days: 5)),
        reason: 'Attending family function over the long weekend.',
        emergencyContact: '+91 98450 12345 (Father)',
        status: LeaveStatus.approved,
        appliedAt: DateTime.now().subtract(const Duration(days: 1)),
        approvedBy: 'Dr. S. K. Nair (Chief Warden)',
        remarks: 'Approved. Gate pass QR generated. Please return by 9:00 PM on Sunday.',
      ),
      HostelLeaveRequest(
        id: 'lev-2',
        leaveType: 'Academic Event',
        fromDate: DateTime.now().add(const Duration(days: 10)),
        toDate: DateTime.now().add(const Duration(days: 12)),
        reason: 'Participating in Smart India Hackathon zonal round.',
        emergencyContact: '+91 98450 12345 (Father)',
        status: LeaveStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    // Notices
    _notices = [
      HostelNotice(
        id: 'not-1',
        title: 'Mandatory Room Inspection Tomorrow',
        content: 'Chief Warden and Floor Tutors will conduct routine cleanliness and electrical safety inspection in Block A from 10:00 AM to 1:00 PM. Please ensure rooms are tidy and unapproved appliances are kept unplugged.',
        category: 'INSPECTION',
        date: DateTime.now(),
        isPinned: true,
      ),
      HostelNotice(
        id: 'not-2',
        title: 'Mess Timing Extension for Exam Week',
        content: 'Dinner timings have been extended by 30 minutes (7:30 PM to 10:00 PM) during upcoming mid-term internal examinations. Late night hot milk & biscuits counter will operate near central mess at 11:30 PM.',
        category: 'MESS',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: true,
      ),
      HostelNotice(
        id: 'not-3',
        title: 'Solar Water Maintenance on Saturday',
        content: 'Routine descaling and solar collector maintenance for Block A & B will be conducted on Saturday between 2:00 PM and 5:00 PM. Hot water supply will resume by 6:00 PM.',
        category: 'MAINTENANCE',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      HostelNotice(
        id: 'not-4',
        title: 'Inter-Block Cricket & Chess Tournament',
        content: 'Registrations are open for Hostel Premier League 2026. Register your floor team with the Sports Secretary before Friday evening.',
        category: 'EVENT',
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    // Hostel Fee
    _hostelFee = HostelFee(
      totalFee: 48500.0,
      paidAmount: 48500.0,
      pendingAmount: 0.0,
      dueDate: DateTime.now().add(const Duration(days: 45)),
      semester: 'Semester V (Autumn 2026)',
      status: 'PAID',
      breakdown: [
        {'title': 'Hostel Room Rent (4 Sharing Deluxe)', 'amount': '₹22,000', 'status': 'Paid'},
        {'title': 'Mess Advance & Catering (5 Months)', 'amount': '₹20,000', 'status': 'Paid'},
        {'title': 'Electricity & Generator Backup', 'amount': '₹3,500', 'status': 'Paid'},
        {'title': 'Hostel Amenities & High-Speed Wi-Fi', 'amount': '₹2,000', 'status': 'Paid'},
        {'title': 'Refundable Caution Deposit', 'amount': '₹1,000', 'status': 'Paid'},
      ],
    );

    // Emergency Contacts
    _emergencyContacts = [
      HostelEmergencyContact(
        role: 'Hostel Chief Warden',
        name: 'Dr. S. K. Nair',
        phoneNumber: '+91 94470 12345',
        availability: 'Available 24x7 for urgent matters',
        location: 'Warden Quarters, Block A Ground Floor',
      ),
      HostelEmergencyContact(
        role: 'Resident Tutor / Assistant Warden',
        name: 'Prof. Ananya Sen',
        phoneNumber: '+91 94470 67890',
        availability: '6:00 PM - 8:00 AM & Weekends',
        location: 'Room 101, Block A',
      ),
      HostelEmergencyContact(
        role: 'Campus Security Control Room',
        name: 'Main Gate Security Station',
        phoneNumber: '+91 495 2286100',
        availability: '24x7 Emergency Patrol',
        location: 'Main Campus Entrance Gate 1',
      ),
      HostelEmergencyContact(
        role: 'Campus Health Centre & Ambulance',
        name: 'Dr. Manoj & Duty Nurse',
        phoneNumber: '+91 495 2286111',
        availability: '24x7 On-call Medical Emergency',
        location: 'Health Centre near Sports Complex',
      ),
    ];
  }

  // Interactive Actions
  void submitComplaint({
    required String title,
    required String description,
    required ComplaintCategory category,
  }) {
    final newComplaint = HostelComplaint(
      id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      category: category,
      status: ComplaintStatus.pending,
      roomNumber: _room.roomNumber,
      createdAt: DateTime.now(),
    );

    _complaints.insert(0, newComplaint);
    notifyListeners();
  }

  void submitLeaveRequest({
    required String leaveType,
    required DateTime fromDate,
    required DateTime toDate,
    required String reason,
    required String emergencyContact,
  }) {
    final newLeave = HostelLeaveRequest(
      id: 'lev-${DateTime.now().millisecondsSinceEpoch}',
      leaveType: leaveType,
      fromDate: fromDate,
      toDate: toDate,
      reason: reason,
      emergencyContact: emergencyContact,
      status: LeaveStatus.pending,
      appliedAt: DateTime.now(),
    );

    _leaveRequests.insert(0, newLeave);
    notifyListeners();
  }

  void updateMessMenuForDay(String dayOfWeek, {required String breakfast, required String lunch, required String dinner}) {
    final idx = _weeklyMessMenu.indexWhere((m) => m.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase());
    if (idx != -1) {
      _weeklyMessMenu[idx] = _weeklyMessMenu[idx].copyWith(
        breakfast: breakfast,
        lunch: lunch,
        dinner: dinner,
      );
      notifyListeners();
    }
  }

  void toggleAttendance() {
    _isTodayPresent = !_isTodayPresent;
    notifyListeners();
  }
}
