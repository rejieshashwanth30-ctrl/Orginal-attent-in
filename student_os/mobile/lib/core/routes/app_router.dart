import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/achievements/achievements_screen.dart';
import '../../screens/ai_assistant/ai_assistant_screen.dart';
import '../../screens/assignments/assignments_screen.dart';
import '../../screens/attendance/attendance_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/calendar/calendar_screen.dart';
import '../../screens/canteen/canteen_cart_screen.dart';
import '../../screens/canteen/canteen_list_screen.dart';
import '../../screens/canteen/canteen_menu_screen.dart';
import '../../screens/canteen/canteen_order_success_screen.dart';
import '../../screens/canteen/canteen_order_tracking_screen.dart';
import '../../screens/canteen/canteen_orders_screen.dart';
import '../../screens/cgpa/cgpa_screen.dart';
import '../../screens/clubs/clubs_screen.dart';
import '../../screens/courses/courses_screen.dart';
import '../../screens/exams/exams_screen.dart';
import '../../screens/flashcards/flashcard_study_screen.dart';
import '../../screens/flashcards/flashcards_generate_screen.dart';
import '../../screens/flashcards/flashcards_home_screen.dart';
import '../../screens/hackathons/hackathons_screen.dart';
import '../../screens/hostel/hostel_complaints_screen.dart';
import '../../screens/hostel/hostel_fees_screen.dart';
import '../../screens/hostel/hostel_leave_screen.dart';
import '../../screens/hostel/hostel_management_screen.dart';
import '../../screens/hostel/hostel_mess_screen.dart';
import '../../screens/hostel/hostel_notices_screen.dart';
import '../../screens/hostel/hostel_room_screen.dart';
import '../../screens/internships/internships_screen.dart';
import '../../screens/jobs/jobs_screen.dart';
import '../../screens/library/library_screen.dart';
import '../../screens/main_layout/main_layout_screen.dart';
import '../../screens/mock_interview/mock_interview_screen.dart';
import '../../screens/more/more_screen.dart';
import '../../screens/notes/notes_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/premium/premium_analytics_screen.dart';
import '../../screens/premium/premium_subscription_screen.dart';
import '../../screens/profile/profile_edit_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../screens/quiz/quiz_home_screen.dart';
import '../../screens/quiz/quiz_play_screen.dart';
import '../../screens/quiz/quiz_result_screen.dart';
import '../../screens/resources/resources_screen.dart';
import '../../screens/resume/resume_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/skills/skills_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/study_planner/study_planner_screen.dart';
import '../../screens/timetable/timetable_screen.dart';
import '../../screens/transport/transport_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      routes: [
        // Splash
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Main Shell / Layout
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 0),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 0),
        ),
        GoRoute(
          path: '/academics',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 1),
        ),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 2),
        ),
        GoRoute(
          path: '/career',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 3),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const MainLayoutScreen(initialIndex: 4),
        ),

        // Deep Module Routes
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
        GoRoute(
          path: '/attendance',
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          path: '/timetable',
          builder: (context, state) => const TimetableScreen(),
        ),
        GoRoute(
          path: '/assignments',
          builder: (context, state) => const AssignmentsScreen(),
        ),
        GoRoute(
          path: '/exams',
          builder: (context, state) => const ExamsScreen(),
        ),
        GoRoute(
          path: '/notes',
          builder: (context, state) => const NotesScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/study-planner',
          builder: (context, state) => const StudyPlannerScreen(),
        ),
        GoRoute(
          path: '/hackathons',
          builder: (context, state) => const HackathonsScreen(),
        ),
        GoRoute(
          path: '/internships',
          builder: (context, state) => const InternshipsScreen(),
        ),
        GoRoute(
          path: '/jobs',
          builder: (context, state) => const JobsScreen(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CoursesScreen(),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsScreen(),
        ),
        GoRoute(
          path: '/resources',
          builder: (context, state) => const ResourcesScreen(),
        ),
        GoRoute(
          path: '/skills',
          builder: (context, state) => const SkillsScreen(),
        ),
        GoRoute(
          path: '/resume',
          builder: (context, state) => const ResumeScreen(),
        ),
        GoRoute(
          path: '/mock-interview',
          builder: (context, state) => const MockInterviewScreen(),
        ),
        GoRoute(
          path: '/ai-assistant',
          builder: (context, state) => const AIAssistantScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/profile-edit',
          builder: (context, state) => const ProfileEditScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),

        // New Expanded Modules
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryScreen(),
        ),
        GoRoute(
          path: '/clubs',
          builder: (context, state) => const ClubsScreen(),
        ),
        GoRoute(
          path: '/cgpa',
          builder: (context, state) => const CgpaScreen(),
        ),

        // Hostel Management Sub-routes
        GoRoute(
          path: '/hostel',
          builder: (context, state) => const HostelManagementScreen(),
        ),
        GoRoute(
          path: '/hostel/room',
          builder: (context, state) => const HostelRoomScreen(),
        ),
        GoRoute(
          path: '/hostel/mess',
          builder: (context, state) => const HostelMessScreen(),
        ),
        GoRoute(
          path: '/hostel/complaints',
          builder: (context, state) => const HostelComplaintsScreen(),
        ),
        GoRoute(
          path: '/hostel/leave',
          builder: (context, state) => const HostelLeaveScreen(),
        ),
        GoRoute(
          path: '/hostel/notices',
          builder: (context, state) => const HostelNoticesScreen(),
        ),
        GoRoute(
          path: '/hostel/fees',
          builder: (context, state) => const HostelFeesScreen(),
        ),

        // AI Quiz System
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizHomeScreen(),
        ),
        GoRoute(
          path: '/quiz/play',
          builder: (context, state) => const QuizPlayScreen(),
        ),
        GoRoute(
          path: '/quiz/result',
          builder: (context, state) => const QuizResultScreen(),
        ),

        // AI Flashcards System
        GoRoute(
          path: '/flashcards',
          builder: (context, state) => const FlashcardsHomeScreen(),
        ),
        GoRoute(
          path: '/flashcards/generate',
          builder: (context, state) => const FlashcardsGenerateScreen(),
        ),
        GoRoute(
          path: '/flashcards/study',
          builder: (context, state) => const FlashcardStudyScreen(),
        ),

        // Student Achievements
        GoRoute(
          path: '/achievements',
          builder: (context, state) => const AchievementsScreen(),
        ),

        // Campus Transport
        GoRoute(
          path: '/transport',
          builder: (context, state) => const TransportScreen(),
        ),

        // Campus Canteen Pre-Order System
        GoRoute(
          path: '/canteen',
          builder: (context, state) => const CanteenListScreen(),
        ),
        GoRoute(
          path: '/canteen/menu',
          builder: (context, state) => const CanteenMenuScreen(),
        ),
        GoRoute(
          path: '/canteen/cart',
          builder: (context, state) => const CanteenCartScreen(),
        ),
        GoRoute(
          path: '/canteen/orders',
          builder: (context, state) => const CanteenOrdersScreen(),
        ),
        GoRoute(
          path: '/canteen/order-success',
          builder: (context, state) => const CanteenOrderSuccessScreen(),
        ),
        GoRoute(
          path: '/canteen/order-tracking',
          builder: (context, state) => const CanteenOrderTrackingScreen(),
        ),

        // Premium Subscription & Analytics
        GoRoute(
          path: '/premium',
          builder: (context, state) => const PremiumSubscriptionScreen(),
        ),
        GoRoute(
          path: '/premium/analytics',
          builder: (context, state) => const PremiumAnalyticsScreen(),
        ),
      ],
    );
  }
}
