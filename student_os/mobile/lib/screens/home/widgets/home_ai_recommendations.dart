import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class HomeAiRecommendations extends StatelessWidget {
  const HomeAiRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final recommendations = [
      {
        'title': 'AI Quiz Practice',
        'subtitle': 'Test readiness on Machine Learning (CS601)',
        'icon': Icons.quiz_rounded,
        'tag': 'AI RECOMMENDATION',
        'route': '/quiz',
        'gradient': [colors.primary, colors.accentCyan],
      },
      {
        'title': 'Spaced Flashcards',
        'subtitle': '5 flashcards due for revision from your weak topics',
        'icon': Icons.style_rounded,
        'tag': 'SPACED REPETITION',
        'route': '/flashcards',
        'gradient': [const Color(0xFF8B5CF6), colors.primaryLight],
      },
      {
        'title': 'Streak & Achievements',
        'subtitle': '4-day study streak active! Earn 100 XP today',
        'icon': Icons.emoji_events_rounded,
        'tag': 'STUDENT MILESTONE',
        'route': '/achievements',
        'gradient': [const Color(0xFFF59E0B), colors.danger],
      },
      {
        'title': 'Campus Shuttle',
        'subtitle': 'Next Route A shuttle arrives at Main Gate in 8 mins',
        'icon': Icons.directions_bus_rounded,
        'tag': 'CAMPUS TRANSPORT',
        'route': '/transport',
        'gradient': [colors.success, colors.accentCyan],
      },
      {
        'title': 'Canteen Pre-Order',
        'subtitle': 'Pre-order break snacks & lunch from C5, C6, Foodjack & Saibites',
        'icon': Icons.restaurant_rounded,
        'tag': 'CAMPUS DINING',
        'route': '/canteen',
        'gradient': [const Color(0xFFEA580C), colors.primary],
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 14,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI RECOMMENDATIONS & SMART ACTIONS',
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
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              final gradient = rec['gradient'] as List<Color>;

              return InkWell(
                onTap: () => context.push(rec['route'] as String),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border, width: 1),
                    boxShadow: [
                      colors.cardShadow,
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            rec['icon'] as IconData,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec['tag'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rec['title'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: colors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rec['subtitle'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
            },
          ),
        ],
      ),
    );
  }
}
