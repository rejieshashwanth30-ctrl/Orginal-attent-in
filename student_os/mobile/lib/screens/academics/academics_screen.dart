import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';

class AcademicsScreen extends StatelessWidget {
  const AcademicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dashboard = context.watch<DashboardProvider>();
    final attendance = context.watch<AttendanceProvider>();

    final double overallAtt = attendance.summary?.overallPercentage ?? dashboard.data?.attendancePercentage ?? 87.0;
    final int pendingAsgn = dashboard.data?.pendingAssignmentsCount ?? 4;
    final int upcomingExams = dashboard.data?.upcomingExamsCount ?? 3;
    final double gpa = dashboard.data?.gpa ?? 8.7;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Academics Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => context.push('/more'),
            tooltip: 'All Modules',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Top Overview Banner
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.school_rounded, color: colors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Academic Performance',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'CGPA: $gpa / 10.0 • 6 Enrolled Subjects',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Academic Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                StatCard(
                  title: 'Overall Attendance',
                  value: '${overallAtt.toStringAsFixed(1)}%',
                  subtitle: overallAtt < 75 ? '⚠️ Below 75%' : 'Good Standing',
                  icon: Icons.how_to_reg_outlined,
                  accentColor: overallAtt < 75 ? colors.danger : colors.success,
                  onTap: () => context.push('/attendance'),
                ),
                StatCard(
                  title: 'Assignments',
                  value: '$pendingAsgn Pending',
                  subtitle: 'View Deadlines',
                  icon: Icons.assignment_outlined,
                  accentColor: colors.primary,
                  onTap: () => context.push('/assignments'),
                ),
                StatCard(
                  title: 'Semester Exams',
                  value: '$upcomingExams Scheduled',
                  subtitle: 'View Countdowns',
                  icon: Icons.quiz_outlined,
                  accentColor: colors.warning,
                  onTap: () => context.push('/exams'),
                ),
                StatCard(
                  title: 'Class Notes',
                  value: '10 Saved',
                  subtitle: 'Quick Access',
                  icon: Icons.note_alt_outlined,
                  accentColor: colors.secondary,
                  onTap: () => context.push('/notes'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Navigation Cards to Academic Features
            const SectionHeader(title: 'Academic Modules', icon: Icons.category_outlined),

            _buildAcademicNavTile(
              context,
              title: 'Attendance Tracker & Calculator',
              subtitle: 'Track subject attendance, calculate required classes for 75%',
              icon: Icons.how_to_reg_rounded,
              color: colors.success,
              route: '/attendance',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'Weekly Timetable Schedule',
              subtitle: 'Mon-Sat daily class routine, faculty and lecture room numbers',
              icon: Icons.calendar_view_week_rounded,
              color: colors.secondary,
              route: '/timetable',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'Assignments Manager',
              subtitle: 'Pending, In Progress, Completed & Overdue submissions',
              icon: Icons.assignment_turned_in_rounded,
              color: colors.primary,
              route: '/assignments',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'Exams & Syllabus Countdown',
              subtitle: 'Internal, Model, Lab & Semester dates with syllabus modal',
              icon: Icons.quiz_rounded,
              color: colors.warning,
              route: '/exams',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'Class Notes & Search',
              subtitle: 'Searchable rich markdown notes with tags and subject filters',
              icon: Icons.edit_note_rounded,
              color: colors.accent,
              route: '/notes',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'Academic Calendar',
              subtitle: 'Unified view of timetable, assignments, exams and campus events',
              icon: Icons.calendar_month_rounded,
              color: colors.categoryAcademic,
              route: '/calendar',
              colors: colors,
            ),
            _buildAcademicNavTile(
              context,
              title: 'AI Smart Study Planner',
              subtitle: 'Generate daily/weekly schedules based on your target exam dates',
              icon: Icons.model_training_rounded,
              color: colors.categoryProject,
              route: '/study-planner',
              colors: colors,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicNavTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
    required AppColorPalette colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => context.push(route),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colors.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}
