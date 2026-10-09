import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/notification_provider.dart';
import 'widgets/ai_assistant_card.dart';
import 'widgets/home_ai_insights.dart';
import 'widgets/home_ai_recommendations.dart';
import 'widgets/home_exams_section.dart';
import 'widgets/home_tasks_section.dart';
import 'widgets/home_upcoming_classes.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/student_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
      context.read<DashboardProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      color: colors.background,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isDesktop = maxWidth > 1024;
            final bool isTablet = maxWidth > 600 && maxWidth <= 1024;

            // Maximum bounded width for desktop and tablet displays
            final double contentMaxWidth = isDesktop ? 1200.0 : (isTablet ? 900.0 : double.infinity);

            final double bottomInset = MediaQuery.of(context).padding.bottom;
            final double safeBottom = bottomInset > 0 ? bottomInset + 8.0 : 16.0;
            final double contentBottomPadding = safeBottom + 68.0 + 20.0;

            return RefreshIndicator(
              color: colors.primary,
              backgroundColor: colors.card,
              onRefresh: () async {
                await Future.wait([
                  context.read<NotificationProvider>().fetchNotifications(),
                  context.read<DashboardProvider>().fetchDashboard(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: contentBottomPadding, // Safe padding for the floating navigation dock
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                    ),
                    child: isDesktop
                        ? _buildDesktopLayout(context)
                        : _buildMobileLayout(context),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Mobile & Tablet Single-Column Layout (< 1024px)
  Widget _buildMobileLayout(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Header: ATTENT-IN wordmark, Logo, Notification bell, Greeting, Subtitle
        StudentHeader(),

        SizedBox(height: 16),

        // 2. Dominant AI Assistant Copilot Card
        AIAssistantCard(),

        SizedBox(height: 20),

        // 3. AI Insights Section (Attendance, Academic, Study, Career)
        HomeAiInsights(),

        SizedBox(height: 20),

        // 4. Quick Access 6-Item Focused Grid with View All
        QuickAccessGrid(),

        SizedBox(height: 24),

        // 5. Today's Classes Schedule
        HomeUpcomingClasses(),

        SizedBox(height: 24),

        // 6. Priority Assignments & Tasks
        HomeTasksSection(),

        SizedBox(height: 24),

        // 7. Upcoming Exams Countdown
        HomeExamsSection(),

        SizedBox(height: 24),

        // 8. AI Recommendations & Smart Actions
        HomeAiRecommendations(),
      ],
    );
  }

  /// Desktop Responsive 2-Column Dashboard Layout (> 1024px, Max Width 1200px)
  Widget _buildDesktopLayout(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Header
        StudentHeader(),

        SizedBox(height: 18),

        // 2. Dominant AI Assistant Hero Card
        AIAssistantCard(),

        SizedBox(height: 24),

        // 3. Responsive 2-Column Split
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (AI Insights, Quick Access, Today's Classes)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAiInsights(),
                  SizedBox(height: 24),
                  QuickAccessGrid(),
                  SizedBox(height: 24),
                  HomeUpcomingClasses(),
                ],
              ),
            ),

            SizedBox(width: 24),

            // Right Column (Priority Tasks, Upcoming Exams, AI Recommendations)
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeTasksSection(),
                  SizedBox(height: 24),
                  HomeExamsSection(),
                  SizedBox(height: 24),
                  HomeAiRecommendations(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
