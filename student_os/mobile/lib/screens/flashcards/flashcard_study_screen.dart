import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/flashcard.dart';
import '../../providers/flashcard_provider.dart';

class FlashcardStudyScreen extends StatefulWidget {
  const FlashcardStudyScreen({super.key});

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_animCtrl.isAnimating) return;
    if (_isFront) {
      _animCtrl.forward();
      setState(() => _isFront = false);
    } else {
      _animCtrl.reverse();
      setState(() => _isFront = true);
    }
  }

  void _handleRating(FlashcardProvider provider, CardDifficulty rating) {
    if (!_isFront) {
      _animCtrl.reverse();
      _isFront = true;
    }
    provider.rateCurrentCard(rating);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final flashcardProvider = context.watch<FlashcardProvider>();
    final set = flashcardProvider.activeSet;

    if (set == null || flashcardProvider.currentCard == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('Flashcards Study')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No flashcard deck selected.', style: TextStyle(color: colors.secondaryText)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.go('/flashcards'), child: const Text('Back to Flashcards')),
            ],
          ),
        ),
      );
    }

    final card = flashcardProvider.currentCard!;
    final total = set.cards.length;
    final currentIdx = flashcardProvider.currentCardIndex;
    final progress = (currentIdx + 1) / total;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(set.title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: colors.primaryText)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go('/flashcards'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.elevatedCard,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              minHeight: 3,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Text(
                      '${set.unit} • ${card.topic}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.secondaryText,
                      ),
                    ),
                  ),
                  Text(
                    'Card ${currentIdx + 1} of $total',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Large Centered Flip Card Widget
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final angle = _animation.value * pi;
                        final isUnder = angle > pi / 2;

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // perspective
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: isUnder
                              ? Transform(
                                  transform: Matrix4.identity()..rotateY(pi),
                                  alignment: Alignment.center,
                                  child: _buildBackCard(card, colors),
                                )
                              : _buildFrontCard(card, colors),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Rating Controls (Spaced Repetition in Blue/Navy Palette)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: colors.card,
                border: Border(top: BorderSide(color: colors.border, width: 1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How well did you know this concept?',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Difficult
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.danger,
                            backgroundColor: colors.danger.withValues(alpha: 0.1),
                            side: BorderSide(color: colors.danger, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _handleRating(flashcardProvider, CardDifficulty.difficult),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sentiment_dissatisfied_outlined, size: 20, color: colors.danger),
                              const SizedBox(height: 3),
                              Text('Difficult', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.danger)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Good
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.warning,
                            backgroundColor: colors.warning.withValues(alpha: 0.1),
                            side: BorderSide(color: colors.warning, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _handleRating(flashcardProvider, CardDifficulty.good),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sentiment_neutral_outlined, size: 20, color: colors.warning),
                              const SizedBox(height: 3),
                              Text('Good', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.warning)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Easy
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: colors.success,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _handleRating(flashcardProvider, CardDifficulty.easy),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.sentiment_very_satisfied_outlined, size: 20, color: Colors.white),
                              const SizedBox(height: 3),
                              Text('Easy', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(Flashcard card, AppColorPalette colors) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280, maxHeight: 380),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.border,
          width: 1.2,
        ),
        boxShadow: [
          colors.cardShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUESTION / CONCEPT',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colors.primary,
                ),
              ),
              Icon(Icons.touch_app_outlined, size: 16, color: colors.primary),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              card.front,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.primaryText,
                height: 1.45,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flip_camera_android_rounded, size: 14, color: colors.secondaryText),
              const SizedBox(width: 6),
              Text(
                'Tap card to reveal answer',
                style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Flashcard card, AppColorPalette colors) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280, maxHeight: 380),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.elevatedCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.primary,
          width: 1.5,
        ),
        boxShadow: [
          colors.cardShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ANSWER & EXPLANATION',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colors.primary,
                ),
              ),
              Icon(Icons.check_circle_outline_rounded, size: 16, color: colors.success),
            ],
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    card.back,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.primaryText,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flip_camera_android_rounded, size: 14, color: colors.secondaryText),
              const SizedBox(width: 6),
              Text(
                'Tap again to flip back',
                style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
