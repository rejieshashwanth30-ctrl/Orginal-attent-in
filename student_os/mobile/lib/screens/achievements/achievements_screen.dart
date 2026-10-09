import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/achievement.dart';
import '../../providers/achievement_provider.dart';
import '../../widgets/app_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final achievementProvider = context.watch<AchievementProvider>();
    final progress = achievementProvider.progress;
    final achievements = achievementProvider.filteredAchievements;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Student Achievements'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Dashboard Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colors.border, width: 1),
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ACHIEVEMENTS & HONORS',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: colors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Academic and career milestone tracker',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.emoji_events_rounded, size: 22, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Metrics Strip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetric('${progress.totalUnlocked}', 'Unlocked', Icons.emoji_events_outlined, colors.success, colors),
                        Container(width: 1, height: 26, color: colors.border),
                        _buildMetric('${progress.totalLocked}', 'Locked', Icons.lock_outline, colors.mutedText, colors),
                        Container(width: 1, height: 26, color: colors.border),
                        _buildMetric('${progress.studyStreakDays} Days', 'Study Streak', Icons.local_fire_department_rounded, colors.warning, colors),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // AI Achievement Recommendations
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Icon(Icons.auto_awesome, color: colors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Goal Recommendation',
                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress.aiGoalRecommendations.first,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: colors.secondaryText,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Category Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildCategoryChip(
                      label: 'All (${achievementProvider.allAchievements.length})',
                      isSelected: achievementProvider.selectedCategory == null,
                      onTap: () => achievementProvider.setCategory(null),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Academic',
                      isSelected: achievementProvider.selectedCategory == AchievementCategory.academic,
                      onTap: () => achievementProvider.setCategory(AchievementCategory.academic),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Learning',
                      isSelected: achievementProvider.selectedCategory == AchievementCategory.learning,
                      onTap: () => achievementProvider.setCategory(AchievementCategory.learning),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Career',
                      isSelected: achievementProvider.selectedCategory == AchievementCategory.career,
                      onTap: () => achievementProvider.setCategory(AchievementCategory.career),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Campus',
                      isSelected: achievementProvider.selectedCategory == AchievementCategory.campus,
                      onTap: () => achievementProvider.setCategory(AchievementCategory.campus),
                      colors: colors,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Achievements List
              ...achievements.map((ach) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    border: ach.isUnlocked
                        ? BorderSide(color: colors.primary.withValues(alpha: 0.5), width: 1.2)
                        : BorderSide(color: colors.border, width: 0.8),
                    backgroundColor: ach.isUnlocked
                        ? colors.card
                        : colors.elevatedCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Badge
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: ach.isUnlocked
                                ? colors.primary.withValues(alpha: 0.12)
                                : colors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ach.isUnlocked
                                  ? colors.primary.withValues(alpha: 0.4)
                                  : colors.border,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.emoji_events_rounded,
                              size: 22,
                              color: ach.isUnlocked ? colors.primary : colors.mutedText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title & Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ach.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ach.isUnlocked
                                            ? colors.primaryText
                                            : colors.secondaryText,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colors.elevatedCard,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: colors.border, width: 0.8),
                                    ),
                                    child: Text(
                                      '+${ach.rewardPoints} XP',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ach.description,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: ach.isUnlocked ? colors.secondaryText : colors.mutedText,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Progress bar if locked
                              if (!ach.isUnlocked) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress: ${ach.progress}/${ach.target} ${ach.unit}',
                                      style: GoogleFonts.inter(fontSize: 10, color: colors.mutedText),
                                    ),
                                    Text(
                                      '${(ach.progressPercentage * 100).toInt()}%',
                                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: colors.secondaryText),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: ach.progressPercentage,
                                    minHeight: 3,
                                    backgroundColor: colors.elevatedCard,
                                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                                  ),
                                ),
                              ] else if (ach.unlockedAt != null) ...[
                                Text(
                                  'Unlocked ${DateFormat('MMM d, yyyy').format(ach.unlockedAt!)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: colors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String value, String label, IconData icon, Color color, AppColorPalette colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: colors.primaryText,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9.5,
                color: colors.mutedText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorPalette colors,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : colors.secondaryText,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      backgroundColor: colors.card,
      side: BorderSide(color: isSelected ? colors.primary : colors.border),
      onSelected: (_) => onTap(),
    );
  }
}
