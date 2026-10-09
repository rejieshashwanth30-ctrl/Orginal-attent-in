import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'quick_access_card.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Exactly 6 primary Quick Access features for the Home Dashboard
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Attendance',
        'subtitle': 'Track classes & buffer',
        'icon': Icons.calendar_today_outlined,
        'route': '/attendance',
      },
      {
        'title': 'Timetable',
        'subtitle': 'Class & lab schedule',
        'icon': Icons.schedule_outlined,
        'route': '/timetable',
      },
      {
        'title': 'Notes',
        'subtitle': 'Notebook & sync',
        'icon': Icons.edit_note_outlined,
        'route': '/notes',
      },
      {
        'title': 'AI Tutor',
        'subtitle': 'Copilot workspace',
        'icon': Icons.smart_toy_outlined,
        'route': '/ai-assistant',
      },
      {
        'title': 'Assignments',
        'subtitle': 'Deadlines & tasks',
        'icon': Icons.assignment_outlined,
        'route': '/assignments',
      },
      {
        'title': 'Study Plan',
        'subtitle': 'AI roadmap & pacing',
        'icon': Icons.auto_graph_outlined,
        'route': '/study-planner',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with "View All →" button
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'QUICK ACCESS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: colors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.push('/more'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Responsive 2-column grid on mobile (3 columns on wide screens)
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 520) {
                crossAxisCount = 3;
              } else {
                crossAxisCount = 2;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 104,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return QuickAccessCard(
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String?,
                    icon: item['icon'] as IconData,
                    badgeText: item['badge'] as String?,
                    onTap: () => context.push(item['route'] as String),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
