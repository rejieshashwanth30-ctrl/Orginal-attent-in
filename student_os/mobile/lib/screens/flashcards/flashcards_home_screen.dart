import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/flashcard_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class FlashcardsHomeScreen extends StatelessWidget {
  const FlashcardsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final flashcardProvider = context.watch<FlashcardProvider>();
    final sets = flashcardProvider.sets;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('AI Flashcards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: colors.primary),
            tooltip: 'Generate Deck',
            onPressed: () => context.push('/flashcards/generate'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
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
                      children: [
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
                            child: Icon(Icons.style_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACTIVE RECALL DECKS',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: colors.primaryText,
                                ),
                              ),
                              Text(
                                'Spaced Repetition Mastery',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Master complex formulas, terminology, and exam concepts with AI flashcards.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: colors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Generate Flashcards',
                      icon: Icons.auto_awesome,
                      onPressed: () => context.push('/flashcards/generate'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // AI Smart Recommendation Card
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
                      child: Icon(Icons.psychology_outlined, color: colors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Smart Recommendation',
                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                          ),
                          Text(
                            'Practice weak concepts identified from your recent AI quizzes.',
                            style: GoogleFonts.inter(fontSize: 11.5, height: 1.3, color: colors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (sets.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          flashcardProvider.setActiveSet(sets.first);
                          context.push('/flashcards/study');
                        },
                        child: Text('Study', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary)),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Sets Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('YOUR REVISION DECKS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: colors.primaryText)),
                  Text('${sets.length} Decks', style: GoogleFonts.inter(fontSize: 12, color: colors.mutedText)),
                ],
              ),
              const SizedBox(height: 12),

              if (sets.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.style_outlined, size: 48, color: colors.mutedText),
                        const SizedBox(height: 8),
                        Text('No flashcard decks created yet.', style: TextStyle(color: colors.secondaryText)),
                        const SizedBox(height: 12),
                        AppButton(
                          text: 'Create First Deck',
                          onPressed: () => context.push('/flashcards/generate'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...sets.map((set) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      onTap: () {
                        flashcardProvider.setActiveSet(set);
                        context.push('/flashcards/study');
                      },
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colors.elevatedCard,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: colors.border, width: 0.8),
                                ),
                                child: Text(
                                  set.subjectName,
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.primary),
                                ),
                              ),
                              if (set.isFromQuizMistakes)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 0.8),
                                  ),
                                  child: Text('Quiz Review', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: colors.primary)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            set.title,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${set.unit} • ${set.topic}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: colors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildTag('${set.totalCards} Cards', colors),
                                  const SizedBox(width: 6),
                                  if (set.difficultCardsCount > 0)
                                    _buildTag('${set.difficultCardsCount} Difficult', colors),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Study Deck', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 14, color: colors.primary),
                                ],
                              ),
                            ],
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

  Widget _buildTag(String label, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.elevatedCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.border, width: 0.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: colors.secondaryText),
      ),
    );
  }
}
