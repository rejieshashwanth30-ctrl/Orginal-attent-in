import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final quizProvider = context.watch<QuizProvider>();
    final result = quizProvider.lastResult;

    if (result == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('Quiz Result')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No quiz result available.', style: TextStyle(color: colors.secondaryText)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.go('/quiz'), child: const Text('Go to Quizzes')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go('/quiz'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Score Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.border, width: 1),
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'QUIZ COMPLETED',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.subjectName} — ${result.topic}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Large Score Typography
                    Text(
                      '${result.percentage.toInt()}%',
                      style: GoogleFonts.outfit(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: colors.primaryText,
                        letterSpacing: -1.5,
                      ),
                    ),
                    Text(
                      'Score: ${result.score} / ${result.totalQuestions}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3 Metric Pills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatPill('Correct', '${result.correctCount}', Icons.check_circle_outline, colors.success, colors),
                        _buildStatPill('Incorrect', '${result.incorrectCount}', Icons.cancel_outlined, colors.danger, colors),
                        _buildStatPill('Time Taken', result.formattedTime, Icons.timer_outlined, colors.primary, colors),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AI Analysis Header
              Text(
                'AI ANALYSIS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 10),

              // Analysis Card
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Strong Topics
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, size: 16, color: colors.success),
                        const SizedBox(width: 6),
                        Text(
                          'Strong Areas:',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: result.strongTopics.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.success.withValues(alpha: 0.4), width: 0.8),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.success),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Weak Topics
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 16, color: colors.warning),
                        const SizedBox(width: 6),
                        Text(
                          'Needs Improvement:',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: colors.secondaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: result.weakTopics.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.warning.withValues(alpha: 0.4), width: 0.8),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.warning),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // AI Recommendations
                    Text(
                      'AI Recommendations:',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.bold, color: colors.primary),
                    ),
                    const SizedBox(height: 6),
                    ...result.aiRecommendations.map((rec) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('— ', style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary)),
                            Expanded(
                              child: Text(
                                rec,
                                style: GoogleFonts.inter(fontSize: 12, height: 1.4, color: colors.secondaryText),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const Divider(height: 24),

                    // Disclaimer
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 13, color: colors.mutedText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'AI-generated diagnostic assessment — not an official academic grade.',
                            style: GoogleFonts.inter(fontSize: 10.5, color: colors.mutedText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              if (result.incorrectCount > 0)
                AppButton(
                  text: 'Create Flashcards from Mistakes (${result.incorrectCount})',
                  icon: Icons.style_outlined,
                  width: double.infinity,
                  onPressed: () async {
                    final flashcardProvider = context.read<FlashcardProvider>();
                    final set = await flashcardProvider.createFromQuizMistakes(result);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Created flashcard set "${set.title}"!')),
                      );
                      context.push('/flashcards/study');
                    }
                  },
                ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      type: AppButtonType.secondary,
                      text: 'Retry Quiz',
                      icon: Icons.replay_rounded,
                      onPressed: () => context.pushReplacement('/quiz/play'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      type: AppButtonType.secondary,
                      text: 'Practice Weak',
                      icon: Icons.auto_awesome,
                      onPressed: () => context.go('/quiz'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/quiz'),
                  child: Text(
                    'Back to AI Quiz Home',
                    style: GoogleFonts.inter(color: colors.secondaryText, fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, IconData icon, Color color, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.elevatedCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primaryText)),
              Text(label, style: GoogleFonts.inter(fontSize: 9.5, color: colors.mutedText)),
            ],
          ),
        ],
      ),
    );
  }
}
