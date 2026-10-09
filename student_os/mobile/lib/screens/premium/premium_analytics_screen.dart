import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/app_card.dart';

class PremiumAnalyticsScreen extends StatelessWidget {
  const PremiumAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final subProvider = context.watch<SubscriptionProvider>();
    final data = subProvider.analyticsData;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Premium Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Performance Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border, width: 1),
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'LEARNING INTELLIGENCE',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: colors.primaryText,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.primary, width: 0.8),
                          ),
                          child: Text(
                            '+${data.quizImprovementPercent.toInt()}% Trend',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeroStat('Quiz Accuracy', '${data.quizAccuracy}%', Icons.quiz_outlined, colors.primary, colors),
                        _buildHeroStat('Study Streak', '${data.currentStudyStreakDays} Days', Icons.local_fire_department_rounded, colors.warning, colors),
                        _buildHeroStat('CGPA', '${data.currentCgpa}', Icons.school_outlined, colors.primary, colors),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // AI Performance Summary
              Text('AI DIAGNOSTIC INSIGHTS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primaryText)),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: data.aiPersonalizedSummary.map((insight) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: colors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              insight,
                              style: GoogleFonts.inter(fontSize: 12.5, height: 1.4, color: colors.secondaryText),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Quiz Score Trend Line Chart
              Text('QUIZ ACCURACY TREND', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primaryText)),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final dayIdx = val.toInt();
                              if (dayIdx >= 0 && dayIdx < data.weeklyQuizScores.length) {
                                return Text('Q${dayIdx + 1}', style: TextStyle(fontSize: 10, color: colors.mutedText));
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) => Text('${val.toInt()}%', style: TextStyle(fontSize: 9, color: colors.mutedText)),
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 50,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            data.weeklyQuizScores.length,
                            (i) => FlSpot(i.toDouble(), data.weeklyQuizScores[i]),
                          ),
                          isCurved: true,
                          color: colors.primary,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: colors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cross-Module Mastery
              Text('CROSS-MODULE MASTERY', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primaryText)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flashcards Mastered', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                          const SizedBox(height: 4),
                          Text('${data.flashcardsMastered} / ${data.totalFlashcardsReviewed}', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attendance Health', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                          const SizedBox(height: 4),
                          Text('${data.attendancePercentage}%', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.success)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Achievements', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                          const SizedBox(height: 4),
                          Text('${data.achievementsUnlocked} Badges', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.warning)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Career Readiness', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                          const SizedBox(height: 4),
                          Text('${data.careerReadinessScore} / 100', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, IconData icon, Color color, AppColorPalette colors) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: colors.primaryText),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: colors.mutedText),
        ),
      ],
    );
  }
}
