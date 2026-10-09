import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quiz.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  void _handleSubmitOrNext(QuizProvider quizProvider) {
    if (quizProvider.isLastQuestion) {
      final result = quizProvider.submitQuiz();
      if (result != null && mounted) {
        context.pushReplacement('/quiz/result');
      }
    } else {
      quizProvider.nextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final quizProvider = context.watch<QuizProvider>();
    final quiz = quizProvider.activeQuiz;

    if (quiz == null || quizProvider.currentQuestion == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('AI Quiz')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No active quiz found.', style: TextStyle(color: colors.secondaryText)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
            ],
          ),
        ),
      );
    }

    final question = quizProvider.currentQuestion!;
    final total = quiz.questions.length;
    final currentIdx = quizProvider.currentQuestionIndex;
    final progress = (currentIdx + 1) / total;

    // Formatting timer MM:SS
    final minutes = (quizProvider.secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (quizProvider.secondsElapsed % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          quiz.subjectName,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryText),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: colors.primary),
                const SizedBox(width: 5),
                Text(
                  '$minutes:$seconds',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tag Row
                    Row(
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
                            '${quiz.topic} • ${question.difficulty}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.secondaryText,
                            ),
                          ),
                        ),
                        if (quiz.isAdaptive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.elevatedCard,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: colors.primary.withValues(alpha: 0.5), width: 0.8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bolt_outlined, size: 12, color: colors.primary),
                                const SizedBox(width: 3),
                                Text('Adaptive', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primary)),
                              ],
                            ),
                          ),
                        Text(
                          'Question ${currentIdx + 1} / $total',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          colors.cardShadow,
                        ],
                      ),
                      child: Text(
                        question.question,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          color: colors.primaryText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Options List
                    Text(
                      question.questionType == QuizQuestionType.multipleSelect
                          ? 'Select all applicable options:'
                          : 'Choose the correct option:',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(question.options.length, (optIdx) {
                      final optionText = question.options[optIdx];
                      final optionLabel = String.fromCharCode(65 + optIdx); // A, B, C, D

                      bool isSelected = false;
                      if (question.questionType == QuizQuestionType.multipleSelect) {
                        if (question.userSelection is List) {
                          isSelected = (question.userSelection as List).contains(optIdx);
                        }
                      } else if (question.questionType == QuizQuestionType.trueFalse) {
                        isSelected = question.userSelection == (optIdx == 0);
                      } else {
                        isSelected = question.userSelection == optIdx;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            if (question.questionType == QuizQuestionType.trueFalse) {
                              quizProvider.selectOption(optIdx == 0);
                            } else {
                              quizProvider.selectOption(optIdx);
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.elevatedCard : colors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? colors.primary : colors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected ? colors.primary : colors.elevatedCard,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      optionLabel,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : colors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? colors.primaryText : colors.secondaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Explanation Toggle Card
                    if (question.userSelection != null) ...[
                      InkWell(
                        onTap: () => quizProvider.toggleExplanation(),
                        child: Row(
                          children: [
                            Icon(
                              quizProvider.showExplanation
                                  ? Icons.visibility_off_outlined
                                  : Icons.lightbulb_outline_rounded,
                              size: 16,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              quizProvider.showExplanation ? 'Hide AI Explanation' : 'View AI Explanation & Concept Breakdown',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (quizProvider.showExplanation) ...[
                        const SizedBox(height: 8),
                        AppCard(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: colors.elevatedCard,
                          border: BorderSide(color: colors.border, width: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Explanation 💡',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                question.explanation,
                                style: GoogleFonts.inter(fontSize: 12.5, height: 1.4, color: colors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: colors.card,
                border: Border(
                  top: BorderSide(
                    color: colors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (currentIdx > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, size: 18, color: colors.primaryText),
                      onPressed: () => quizProvider.previousQuestion(),
                    ),
                  const Spacer(),
                  AppButton(
                    text: quizProvider.isLastQuestion ? 'Submit Quiz' : 'Next Question',
                    icon: quizProvider.isLastQuestion ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                    onPressed: () => _handleSubmitOrNext(quizProvider),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
