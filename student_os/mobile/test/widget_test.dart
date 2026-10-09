import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_os/core/constants/app_colors.dart';
import 'package:student_os/core/theme/app_theme.dart';
import 'package:student_os/core/utils/attendance_calculator.dart';
import 'package:student_os/models/assignment.dart';
import 'package:student_os/models/hostel_models.dart';
import 'package:student_os/models/note.dart';
import 'package:student_os/models/task.dart';
import 'package:student_os/providers/auth_provider.dart';
import 'package:student_os/providers/cgpa_provider.dart';
import 'package:student_os/providers/club_provider.dart';
import 'package:student_os/providers/dashboard_provider.dart';
import 'package:student_os/providers/hostel_provider.dart';
import 'package:student_os/providers/library_provider.dart';
import 'package:student_os/providers/notes_copilot_provider.dart';
import 'package:student_os/providers/notification_provider.dart';
import 'package:student_os/providers/theme_provider.dart';
import 'package:student_os/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:student_os/screens/home/home_screen.dart';
import 'package:student_os/screens/main_layout/main_layout_screen.dart';
import 'package:student_os/screens/home/widgets/ai_assistant_card.dart';
import 'package:student_os/screens/home/widgets/home_ai_insights.dart';
import 'package:student_os/screens/home/widgets/home_ai_recommendations.dart';
import 'package:student_os/screens/home/widgets/home_exams_section.dart';
import 'package:student_os/screens/home/widgets/home_tasks_section.dart';
import 'package:student_os/screens/home/widgets/home_upcoming_classes.dart';
import 'package:student_os/screens/home/widgets/quick_access_grid.dart';
import 'package:student_os/screens/home/widgets/student_header.dart';
import 'package:student_os/screens/main_layout/widgets/ai_core_button.dart';
import 'package:student_os/screens/main_layout/widgets/ai_floating_dock.dart';
import 'package:student_os/screens/more/more_screen.dart';
import 'package:student_os/screens/settings/settings_screen.dart';
import 'package:student_os/services/storage_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('AttendanceCalculator Tests', () {
    test('Calculates correct attendance percentage', () {
      final pct = AttendanceCalculator.calculatePercentage(18, 24);
      expect(pct, equals(75.0));
    });

    test('Calculates classes needed when below 75%', () {
      // 10 attended out of 20 = 50%.
      final needed = AttendanceCalculator.calculateClassesNeeded(10, 20);
      expect(needed, equals(20));
    });

    test('Calculates safe classes to miss when above 75%', () {
      // 30 attended out of 30 = 100%.
      final safeToMiss = AttendanceCalculator.calculateClassesCanMiss(30, 30);
      expect(safeToMiss, equals(10));
    });
  });

  group('Model Serialization Tests', () {
    test('Assignment model correctly parses JSON', () {
      final json = {
        'id': 'asgn-1',
        'title': 'Operating Systems Project',
        'subjectName': 'Operating Systems',
        'description': 'Implement semaphore locking',
        'dueDate': '2026-09-15T00:00:00.000Z',
        'priority': 'HIGH',
        'status': 'PENDING',
        'maxMarks': 100,
      };

      final asgn = Assignment.fromJson(json);
      expect(asgn.id, equals('asgn-1'));
      expect(asgn.title, equals('Operating Systems Project'));
      expect(asgn.priority, equals('HIGH'));
    });

    test('Task model correctly parses JSON', () {
      final json = {
        'id': 'task-1',
        'title': 'LeetCode Daily Challenge',
        'category': 'CAREER',
        'priority': 'HIGH',
        'isCompleted': false,
        'dueDate': '2026-09-01T00:00:00.000Z',
      };

      final task = Task.fromJson(json);
      expect(task.id, equals('task-1'));
      expect(task.isCompleted, isFalse);
      expect(task.category, equals('CAREER'));
    });
  });

  group('Hostel Management Tests', () {
    test('HostelRoom serialization works correctly', () {
      final json = {
        'roomNumber': '204',
        'block': 'Block A',
        'floor': '2nd Floor',
        'roomType': '4 Sharing',
        'sharingCapacity': 4,
        'currentOccupancy': 4,
        'amenities': ['Wi-Fi', 'Balcony'],
        'roommates': [
          {
            'id': 'rm-1',
            'name': 'Aarav Sharma',
            'department': 'CSE',
            'year': 3,
            'rollNumber': '21BCSE088',
            'phone': '+91 9876543210',
            'roomBed': 'Bed A',
          }
        ],
      };

      final room = HostelRoom.fromJson(json);
      expect(room.roomNumber, equals('204'));
      expect(room.block, equals('Block A'));
      expect(room.roommates.length, equals(1));
      expect(room.roommates.first.name, equals('Aarav Sharma'));
    });

    test('HostelProvider submits complaint and updates list', () {
      final provider = HostelProvider();
      final initialCount = provider.complaints.length;

      provider.submitComplaint(
        title: 'Light Flickering',
        description: 'Fluorescent tubelight flickering in study room',
        category: ComplaintCategory.electrical,
      );

      expect(provider.complaints.length, equals(initialCount + 1));
      expect(provider.complaints.first.title, equals('Light Flickering'));
      expect(provider.complaints.first.category, equals(ComplaintCategory.electrical));
      expect(provider.complaints.first.status, equals(ComplaintStatus.pending));
    });

    test('HostelProvider submits leave request and toggles attendance', () {
      final provider = HostelProvider();
      final initialLeaves = provider.leaveRequests.length;

      provider.submitLeaveRequest(
        leaveType: 'Home Visit',
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(const Duration(days: 2)),
        reason: 'Festival holiday with parents',
        emergencyContact: '+91 98765 43210',
      );

      expect(provider.leaveRequests.length, equals(initialLeaves + 1));
      expect(provider.leaveRequests.first.leaveType, equals('Home Visit'));
      expect(provider.leaveRequests.first.status, equals(LeaveStatus.pending));

      final initialAttendance = provider.isTodayPresent;
      provider.toggleAttendance();
      expect(provider.isTodayPresent, equals(!initialAttendance));
    });
  });

  group('Library Management Tests', () {
    test('LibraryProvider search and category filters work', () {
      final provider = LibraryProvider();
      expect(provider.allBooks.isNotEmpty, isTrue);

      provider.setSearchQuery('Deep Learning');
      expect(provider.filteredBooks.length, equals(1));
      expect(provider.filteredBooks.first.title.contains('Deep Learning'), isTrue);

      provider.setSearchQuery('');
      provider.setSelectedCategory('CSE');
      expect(provider.filteredBooks.every((b) => b.department == 'CSE'), isTrue);
    });

    test('LibraryProvider borrows and renews book', () {
      final provider = LibraryProvider();
      final book = provider.allBooks.first;
      final initialBorrowedCount = provider.borrowedBooks.length;

      provider.borrowBook(book);
      expect(provider.borrowedBooks.length, equals(initialBorrowedCount + 1));
      expect(provider.borrowedBooks.first.bookTitle, equals(book.title));

      final firstBorrowId = provider.borrowedBooks.first.id;
      final oldDueDate = provider.borrowedBooks.first.dueDate;
      provider.renewBook(firstBorrowId);
      expect(provider.borrowedBooks.first.dueDate.isAfter(oldDueDate), isTrue);
    });
  });

  group('Clubs & Activities Tests', () {
    test('ClubProvider toggles join and event registration', () {
      final provider = ClubProvider();
      final club = provider.clubs.first;
      final initialJoined = club.isJoined;
      final initialMembers = club.memberCount;

      provider.toggleJoinClub(club.id);
      final updatedClub = provider.clubs.firstWhere((c) => c.id == club.id);
      expect(updatedClub.isJoined, equals(!initialJoined));
      expect(updatedClub.memberCount, equals(initialJoined ? initialMembers - 1 : initialMembers + 1));

      final firstEvent = provider.allUpcomingEvents.first;
      final initialEventReg = firstEvent.isRegistered;
      provider.toggleRegisterEvent(firstEvent.id);
      final updatedEvent = provider.allUpcomingEvents.firstWhere((e) => e.id == firstEvent.id);
      expect(updatedEvent.isRegistered, equals(!initialEventReg));
    });
  });

  group('CGPA Calculator & Prediction Tests', () {
    test('CGPA calculation formula is accurate', () {
      final provider = CgpaProvider();
      expect(provider.overallCgpa, isPositive);
      expect(provider.totalCompletedCredits, isPositive);

      // Verify GPA formula calculation
      final sem1 = provider.semesters.first;
      expect(sem1.semesterGpa, isPositive);
      expect(sem1.totalCredits, equals(17));
    });

    test('Target CGPA calculation accurately solves required GPA', () {
      final provider = CgpaProvider();
      final requiredGpa = provider.calculateRequiredGpaForTarget(
        targetCgpa: 9.0,
        remainingCredits: 24,
      );

      expect(requiredGpa, isNotNull);
      expect(requiredGpa!, isPositive);
    });

    test('AI scenario simulator updates projected CGPA', () {
      final provider = CgpaProvider();
      final sim = provider.simulateFutureCgpa([
        {'credits': 4, 'grade': 'S'},
        {'credits': 4, 'grade': 'S'},
      ]);

      expect(sim, isPositive);
      expect(sim, isNot(equals(0.0)));
    });
  });

  group('Notes Copilot Context Tests', () {
    test('NotesCopilotProvider responds to active note context and quick prompts', () async {
      final provider = NotesCopilotProvider();
      final testNote = Note(
        id: 'n-test',
        userId: 'u-1',
        title: 'Neural Networks & Backpropagation',
        content: 'Backpropagation computes the gradient of the loss function with respect to weights using the chain rule.',
        tags: 'ML,AI,DeepLearning',
        isPinned: false,
        updatedAt: DateTime.now(),
      );

      provider.setActiveNote(testNote);
      expect(provider.messages.length, equals(1));
      expect(provider.messages.first.role, equals('copilot'));
      expect(provider.messages.first.sourceIndicator, equals('Based on your uploaded notes'));

      await provider.sendMessage('Summarize this note');
      expect(provider.messages.length, equals(3));
      expect(provider.messages.last.role, equals('copilot'));
      expect(provider.messages.last.content.contains('Summary'), isTrue);
    });
  });

  group('Theme Tokens & Color Palettes Tests', () {
    test('Minimalist Light Mode palette values match specifications', () {
      const light = AppColorPalette.light;
      expect(light.isDark, isFalse);
      expect(light.background, equals(const Color(0xFFF5F6F8)));
      expect(light.secondaryBackground, equals(const Color(0xFFEEF0F3)));
      expect(light.card, equals(const Color(0xFFFFFFFF)));
      expect(light.elevatedCard, equals(const Color(0xFFFAFAFB)));
      expect(light.primaryText, equals(const Color(0xFF171A1F)));
      expect(light.secondaryText, equals(const Color(0xFF626B78)));
      expect(light.mutedText, equals(const Color(0xFF8A929E)));
      expect(light.border, equals(const Color(0xFFE1E4E8)));
      expect(light.primary, equals(const Color(0xFF2563EB)));
      expect(light.secondary, equals(const Color(0xFF3B82F6)));
      expect(light.subtleAccentBg, equals(const Color(0xFFEAF2FF)));
      expect(light.success, equals(const Color(0xFF16A34A)));
      expect(light.warning, equals(const Color(0xFFD97706)));
      expect(light.danger, equals(const Color(0xFFDC2626)));
    });

    test('Deep Monochromatic Dark Mode palette values match specifications', () {
      const dark = AppColorPalette.dark;
      expect(dark.isDark, isTrue);
      expect(dark.background, equals(const Color(0xFF121212)));
      expect(dark.secondaryBackground, equals(const Color(0xFF181A1D)));
      expect(dark.card, equals(const Color(0xFF1E2024)));
      expect(dark.elevatedCard, equals(const Color(0xFF24272C)));
      expect(dark.primaryText, equals(const Color(0xFFF5F5F5)));
      expect(dark.secondaryText, equals(const Color(0xFFB5BAC4)));
      expect(dark.mutedText, equals(const Color(0xFF7F8793)));
      expect(dark.border, equals(const Color(0xFF2D3138)));
      expect(dark.primary, equals(const Color(0xFF5B8CFF)));
      expect(dark.secondary, equals(const Color(0xFF6FA3FF)));
      expect(dark.subtleAccentBg, equals(const Color(0xFF202B42)));
      expect(dark.success, equals(const Color(0xFF4ADE80)));
      expect(dark.warning, equals(const Color(0xFFFBBF24)));
      expect(dark.danger, equals(const Color(0xFFF87171)));
    });

    testWidgets('AppTheme generates valid ThemeData for both Light and Dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SizedBox(),
        ),
      );

      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;

      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.scaffoldBackgroundColor, equals(const Color(0xFFF5F6F8)));

      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.scaffoldBackgroundColor, equals(const Color(0xFF121212)));
    });
  });

  group('ThemeProvider & SettingsScreen Tests', () {
    testWidgets('ThemeProvider persists and switches between Light, Dark, and System modes', (tester) async {
      final themeProvider = ThemeProvider();
      await themeProvider.setThemeMode(ThemeMode.light);
      expect(themeProvider.themeMode, equals(ThemeMode.light));
      expect(StorageService.getThemeMode(), equals('light'));

      await themeProvider.setThemeMode(ThemeMode.dark);
      expect(themeProvider.themeMode, equals(ThemeMode.dark));
      expect(StorageService.getThemeMode(), equals('dark'));

      await themeProvider.setThemeMode(ThemeMode.system);
      expect(themeProvider.themeMode, equals(ThemeMode.system));
      expect(StorageService.getThemeMode(), equals('system'));
    });

    testWidgets('SettingsScreen displays theme options and switches themes', (tester) async {
      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: themeProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Visual Theme & Appearance'), findsOneWidget);
      expect(find.text('Minimalist Light Mode'), findsOneWidget);
      expect(find.text('Deep Monochromatic Dark Mode'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);

      // Tap Minimalist Light Mode
      await tester.tap(find.text('Minimalist Light Mode'));
      await tester.pumpAndSettle();
      expect(themeProvider.themeMode, equals(ThemeMode.light));

      // Tap Deep Monochromatic Dark Mode
      await tester.tap(find.text('Deep Monochromatic Dark Mode'));
      await tester.pumpAndSettle();
      expect(themeProvider.themeMode, equals(ThemeMode.dark));
    });
  });

  group('AI Floating Navigation Dock & AI Core Tests', () {
    testWidgets('AIFloatingDock renders all 5 destinations and triggers callbacks', (tester) async {
      int selectedTab = 0;
      bool aiCoreTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: Scaffold(
            body: const Center(child: Text('Content')),
            bottomNavigationBar: AIFloatingDock(
              currentIndex: selectedTab,
              onTabSelected: (idx) => selectedTab = idx,
              onAICoreTapped: () => aiCoreTapped = true,
            ),
          ),
        ),
      );

      // Verify labels are rendered
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Chats'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(AICoreButton), findsOneWidget);

      // Tap Explore
      await tester.tap(find.text('Explore'));
      await tester.pump();
      expect(selectedTab, equals(1));

      // Tap AI Core
      await tester.tap(find.byType(AICoreButton));
      await tester.pump();
      expect(aiCoreTapped, isTrue);
    });
  });

  group('HomeScreen 6-Feature Focused Dashboard Tests', () {
    testWidgets('HomeScreen renders in Light mode cleanly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // Verify all essential components exist and are mounted
      expect(find.byType(StudentHeader), findsOneWidget);
      expect(find.byType(AIAssistantCard), findsOneWidget);
      expect(find.byType(HomeAiInsights), findsOneWidget);
      expect(find.byType(QuickAccessGrid), findsOneWidget);
      expect(find.byType(HomeUpcomingClasses), findsOneWidget);
      expect(find.byType(HomeTasksSection), findsOneWidget);
      expect(find.byType(HomeExamsSection), findsOneWidget);
      expect(find.byType(HomeAiRecommendations), findsOneWidget);

      // Verify the 6 primary features inside QuickAccessGrid
      final gridFinder = find.byType(QuickAccessGrid);
      expect(find.descendant(of: gridFinder, matching: find.text('Attendance')), findsOneWidget);
      expect(find.descendant(of: gridFinder, matching: find.text('Timetable')), findsOneWidget);
      expect(find.descendant(of: gridFinder, matching: find.text('Notes')), findsOneWidget);
      expect(find.descendant(of: gridFinder, matching: find.text('AI Tutor')), findsOneWidget);
      expect(find.descendant(of: gridFinder, matching: find.text('Assignments')), findsOneWidget);
      expect(find.descendant(of: gridFinder, matching: find.text('Study Plan')), findsOneWidget);
    });

    testWidgets('HomeScreen renders in Dark mode cleanly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(StudentHeader), findsOneWidget);
      expect(find.byType(QuickAccessGrid), findsOneWidget);
    });

    testWidgets('HomeScreen renders responsive Desktop 2-column layout on wide screens (>1024px)', (tester) async {
      tester.view.physicalSize = const Size(1440, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // All sections render cleanly in desktop mode
      expect(find.byType(StudentHeader), findsOneWidget);
      expect(find.byType(AIAssistantCard), findsOneWidget);
      expect(find.byType(HomeAiInsights), findsOneWidget);
      expect(find.byType(QuickAccessGrid), findsOneWidget);
      expect(find.byType(HomeUpcomingClasses), findsOneWidget);
      expect(find.byType(HomeTasksSection), findsOneWidget);
      expect(find.byType(HomeExamsSection), findsOneWidget);
      expect(find.byType(HomeAiRecommendations), findsOneWidget);
    });

    testWidgets('HomeScreen renders cleanly on Tablet screens (600-1024px)', (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(StudentHeader), findsOneWidget);
      expect(find.byType(QuickAccessGrid), findsOneWidget);
    });
  });

  group('Explore Features Directory (MoreScreen) Tests', () {
    testWidgets('MoreScreen renders in both themes and supports search', (tester) async {
      tester.view.physicalSize = const Size(1080, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Categories
      expect(find.text('Explore Features'), findsOneWidget);
      expect(find.text('ACADEMICS'), findsOneWidget);
      expect(find.text('CAMPUS'), findsOneWidget);
      expect(find.text('CAREER'), findsOneWidget);
      expect(find.text('AI TOOLS'), findsOneWidget);

      // Test Search
      await tester.enterText(find.byType(TextField), 'Hostel');
      await tester.pumpAndSettle();

      expect(find.text('SEARCH RESULTS'), findsOneWidget);
      expect(find.text('Hostel Management'), findsOneWidget);
    });
  });

  group('Chat / AI Assistant Page Spacing & Layout Tests', () {
    testWidgets('AIAssistantScreen renders input field, send button, and quick prompts cleanly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AIAssistantScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // Verify header, initial messages, suggestions, text field, send button
      expect(find.text('ATTENT-IN AI'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byTooltip('Send message'), findsOneWidget);
      expect(find.text('Explain Transformer Self-Attention in 3 sentences'), findsOneWidget);

      // Verify typing into input field and sending
      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.tap(find.byTooltip('Send message'));
      await tester.pump();

      expect(find.text('Hello AI'), findsOneWidget);
    });
  });

  group('MainLayoutScreen & SafeArea Bottom Navigation Tests', () {
    testWidgets('MainLayoutScreen places AIFloatingDock and switches tabs without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.padding = const FakeViewPadding(bottom: 96, left: 0, right: 0, top: 72);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetPadding();
      });

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const MainLayoutScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(AIFloatingDock), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);

      // Switch to Chats
      await tester.tap(find.text('Chats'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byTooltip('Send message'), findsOneWidget);
      expect(find.byType(AIFloatingDock), findsOneWidget);
    });
  });
}
