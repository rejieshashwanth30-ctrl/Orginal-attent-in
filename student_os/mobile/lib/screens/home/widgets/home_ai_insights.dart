import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class HomeAiInsights extends StatelessWidget {
  const HomeAiInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final insights = [
      {
        'category': 'ATTENDANCE',
        'stat': '78%',
        'icon': Icons.how_to_reg_outlined,
        'title': 'Attendance Strategy',
        'desc': 'Attend next 2 classes to maintain a safe 80% buffer.',
        'route': '/attendance',
        'badgeColor': colors.warning,
      },
      {
        'category': 'ACADEMIC',
        'stat': '8.72',
        'icon': Icons.school_outlined,
        'title': 'CGPA Projection',
        'desc': 'On track for First Class with Distinction.',
        'route': '/cgpa',
        'badgeColor': colors.primary,
      },
      {
        'category': 'STUDY',
        'stat': '45m',
        'icon': Icons.menu_book_outlined,
        'title': 'Study Focus Tonight',
        'desc': 'Review Deep Learning backpropagation at 7:15 PM.',
        'route': '/study-planner',
        'badgeColor': colors.accentCyan,
      },
      {
        'category': 'CAREER',
        'stat': '82%',
        'icon': Icons.work_outline_rounded,
        'title': 'Target Role Readiness',
        'desc': 'Complete 2 Dynamic Programming problems for placement prep.',
        'route': '/jobs',
        'badgeColor': colors.success,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'AI INSIGHTS',
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
              const SizedBox(width: 8),
              Text(
                'Live Intelligence',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Cards Carousel
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: insights.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = insights[index];
                final badgeColor = item['badgeColor'] as Color;

                return InkWell(
                  onTap: () => context.push(item['route'] as String),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 255,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colors.border,
                        width: 1,
                      ),
                      boxShadow: [
                        colors.cardShadow,
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Header inside card: Category & Stat
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  size: 14,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item['category'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                item['stat'] as String,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Title
                        Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colors.primaryText,
                          ),
                        ),

                        // Description
                        Text(
                          item['desc'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            height: 1.3,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
