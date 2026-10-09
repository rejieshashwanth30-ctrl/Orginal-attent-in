import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/assignment_card.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/error_state.dart';
import '../../widgets/exam_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard();
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dashboard = context.watch<DashboardProvider>();
    final notifProvider = context.watch<NotificationProvider>();
    final auth = context.watch<AuthProvider>();

    final userFullName = auth.user?.profile?.fullName ?? dashboard.data?.greetingName ?? 'Student';
    final studentFirstName = userFullName.split(' ').first;
    final formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await dashboard.fetchDashboard();
            await notifProvider.fetchNotifications();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Modern App Bar Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, $studentFirstName 👋',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedDate,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: colors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Search Icon
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            onPressed: () => context.push('/search'),
                            color: colors.primaryText,
                          ),
                          // Notifications with Badge
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined),
                                onPressed: () => context.push('/notifications'),
                                color: colors.primaryText,
                              ),
                              if (notifProvider.unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: colors.danger,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                    child: Text(
                                      '${notifProvider.unreadCount}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          // Profile Avatar
                          GestureDetector(
                            onTap: () => context.push('/profile'),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: colors.primary,
                              child: Text(
                                studentFirstName.isNotEmpty ? studentFirstName[0].toUpperCase() : 'S',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Offline Mode Banner if cached
              if (dashboard.isOffline)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 16, color: colors.warning),
                        const SizedBox(width: 8),
                        Text(
                          "You're offline. Displaying cached ATTENT-IN data.",
                          style: GoogleFonts.inter(fontSize: 12, color: colors.warning, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

              // Loading & Error States
              if (dashboard.isLoading && dashboard.data == null)
                const SliverFillRemaining(
                  child: AppLoading(message: 'Syncing your ATTENT-IN workspace...'),
                )
              else if (dashboard.error != null && dashboard.data == null)
                SliverFillRemaining(
                  child: AppError(
                    message: dashboard.error!,
                    onRetry: () => dashboard.fetchDashboard(),
                  ),
                )
              else if (dashboard.data != null) ...[
                // Six Key Dashboard Metric Cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 112,
                    ),
                    delegate: SliverChildListDelegate([
                      StatCard(
                        title: 'Attendance',
                        value: '${dashboard.data!.attendancePercentage.toStringAsFixed(0)}%',
                        subtitle: dashboard.data!.attendancePercentage < 75 ? '⚠️ Below 75%' : 'Safe Zone',
                        icon: Icons.how_to_reg_outlined,
                        accentColor: dashboard.data!.attendancePercentage < 75 ? colors.danger : colors.success,
                        onTap: () => context.push('/attendance'),
                      ),
                      StatCard(
                        title: 'Assignments',
                        value: '${dashboard.data!.pendingAssignmentsCount}',
                        subtitle: 'Pending Deadlines',
                        icon: Icons.assignment_outlined,
                        accentColor: colors.primary,
                        onTap: () => context.push('/assignments'),
                      ),
                      StatCard(
                        title: 'Upcoming Exams',
                        value: '${dashboard.data!.upcomingExamsCount}',
                        subtitle: 'Scheduled this month',
                        icon: Icons.quiz_outlined,
                        accentColor: colors.warning,
                        onTap: () => context.push('/exams'),
                      ),
                      StatCard(
                        title: 'Study Hours',
                        value: '${dashboard.data!.studyHours} hrs',
                        subtitle: 'Logged this week',
                        icon: Icons.timer_outlined,
                        accentColor: colors.secondary,
                        onTap: () => context.push('/study-planner'),
                      ),
                      StatCard(
                        title: 'Cumulative GPA',
                        value: '${dashboard.data!.gpa}',
                        subtitle: 'Out of 10.0 Scale',
                        icon: Icons.school_outlined,
                        accentColor: colors.accent,
                        onTap: () => context.push('/academics'),
                      ),
                      StatCard(
                        title: 'Career Readiness',
                        value: '${dashboard.data!.careerReadiness}%',
                        subtitle: 'Profile Score',
                        icon: Icons.trending_up_rounded,
                        accentColor: colors.categoryCareer,
                        onTap: () => context.push('/career'),
                      ),
                    ]),
                  ),
                ),

                // Today's Classes Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                    child: SectionHeader(
                      title: "Today's Classes",
                      icon: Icons.schedule_rounded,
                      actionText: 'Timetable',
                      onActionTap: () => context.push('/timetable'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 140,
                    child: dashboard.data!.todaysClasses.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              'No scheduled classes for today! Enjoy your self-study time.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: colors.secondaryText,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          itemCount: dashboard.data!.todaysClasses.length,
                          itemBuilder: (context, index) {
                            final slot = dashboard.data!.todaysClasses[index];
                            return ClassScheduleCard(
                              slot: slot,
                              isCurrentClass: index == 0,
                              onTap: () => context.push('/timetable'),
                            );
                          },
                        ),
                  ),
                ),

                // Urgent Assignments Section
                if (dashboard.data!.urgentAssignments.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                      child: SectionHeader(
                        title: 'Priority Assignments',
                        icon: Icons.warning_amber_rounded,
                        actionText: 'See All',
                        onActionTap: () => context.push('/assignments'),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final asgn = dashboard.data!.urgentAssignments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AssignmentCard(
                              assignment: asgn,
                              onTap: () => context.push('/assignments'),
                            ),
                          );
                        },
                        childCount: dashboard.data!.urgentAssignments.length,
                      ),
                    ),
                  ),
                ],

                // Upcoming Exams Section
                if (dashboard.data!.nextExams.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                      child: SectionHeader(
                        title: 'Upcoming Exams Countdown',
                        icon: Icons.alarm_on_outlined,
                        actionText: 'Syllabus',
                        onActionTap: () => context.push('/exams'),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final exam = dashboard.data!.nextExams[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ExamCard(
                              exam: exam,
                              onTap: () => context.push('/exams'),
                            ),
                          );
                        },
                        childCount: dashboard.data!.nextExams.length,
                      ),
                    ),
                  ),
                ],

                // Bottom Padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
