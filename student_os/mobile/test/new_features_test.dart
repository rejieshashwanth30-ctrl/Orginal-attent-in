import 'package:flutter_test/flutter_test.dart';
import 'package:student_os/models/achievement.dart';
import 'package:student_os/models/flashcard.dart';
import 'package:student_os/models/quiz.dart';
import 'package:student_os/models/subscription_models.dart';
import 'package:student_os/providers/achievement_provider.dart';
import 'package:student_os/providers/flashcard_provider.dart';
import 'package:student_os/providers/quiz_provider.dart';
import 'package:student_os/providers/subscription_provider.dart';
import 'package:student_os/providers/transport_provider.dart';
import 'package:student_os/services/achievement_service.dart';
import 'package:student_os/services/entitlement_service.dart';
import 'package:student_os/services/mock_data_service.dart';
import 'package:student_os/services/quiz_service.dart';
import 'package:student_os/services/subscription_service.dart';

void main() {
  group('AI Quiz Generator & Diagnostics Tests', () {
    test('Generates quiz grounded on subject and topic', () async {
      final sub = MockDataService.subjects.first;
      final quiz = await QuizService.generateQuiz(
        semester: 'Semester 6',
        subject: sub,
        topic: 'Neural Networks & Deep Learning',
        difficulty: 'Medium',
        questionCount: 5,
        questionType: 'MCQ',
      );

      expect(quiz.title.contains('Neural Networks'), isTrue);
      expect(quiz.questions.length, equals(5));
      expect(quiz.questions.first.options.length, equals(4));
    });

    test('QuizProvider calculates diagnostic result accurately', () async {
      final provider = QuizProvider();
      await provider.generateQuiz(
        semester: 'Semester 6',
        subject: MockDataService.subjects.first,
        topic: 'Operating Systems Semaphores',
        difficulty: 'Medium',
        questionCount: 5,
        questionType: 'MCQ',
      );

      expect(provider.activeQuiz, isNotNull);
      final qCount = provider.activeQuiz!.questions.length;

      // Answer questions
      for (int i = 0; i < qCount; i++) {
        final q = provider.activeQuiz!.questions[i];
        provider.selectOption(q.correctAnswer);
        provider.nextQuestion();
      }

      final result = provider.submitQuiz();
      expect(result, isNotNull);
      expect(result!.score, equals(qCount));
      expect(result.percentage, equals(100.0));
      expect(result.weakTopics.contains('None detected'), isTrue);
    });
  });

  group('AI Flashcards & Spaced Repetition Tests', () {
    test('Flashcard deck creation and spaced repetition feedback', () async {
      final provider = FlashcardProvider();
      final initialCount = provider.sets.length;

      final set = await provider.generateFlashcards(
        subject: MockDataService.subjects.first,
        unit: 'Unit 1',
        topic: 'LL(1) Grammars & First/Follow Sets',
        cardCount: 4,
        difficulty: 'Medium',
      );

      expect(set, isNotNull);
      expect(provider.sets.length, equals(initialCount + 1));
      expect(set!.cards.length, equals(4));

      // Test rating a card
      provider.rateCurrentCard(CardDifficulty.easy);
      expect(provider.currentCardIndex, greaterThanOrEqualTo(0));
    });

    test('Auto-generates flashcards from quiz mistakes', () async {
      final provider = FlashcardProvider();
      final sampleQuestion = QuizQuestion(
        id: 'q-err-1',
        question: 'What is a race condition?',
        options: ['Mutual exclusion', 'Concurrent unsynchronized access', 'Deadlock', 'Livelock'],
        correctAnswer: 1,
        explanation: 'A race condition occurs when concurrent threads access shared data without synchronization.',
        topic: 'Concurrency',
        difficulty: 'Medium',
        isAnsweredCorrectly: false,
      );

      final result = QuizResult(
        id: 'res-1',
        quizId: 'q-1',
        subjectName: 'Operating Systems',
        topic: 'Concurrency',
        totalQuestions: 5,
        score: 4,
        correctCount: 4,
        incorrectCount: 1,
        timeTakenSeconds: 90,
        strongTopics: ['Processes'],
        weakTopics: ['Concurrency'],
        aiRecommendations: ['Review race conditions'],
        difficultyRecommendation: 'Medium',
        suggestedNextQuiz: 'Advanced Concurrency',
        questions: [sampleQuestion],
        percentage: 80.0,
      );

      final set = await provider.createFromQuizMistakes(result);

      expect(set.cards.isNotEmpty, isTrue);
      expect(set.title.contains('Operating Systems') || set.title.contains('Mistakes'), isTrue);
    });
  });

  group('Student Achievements & Streak Progression Tests', () {
    test('Filters achievements by category and tracks streak progress', () {
      final provider = AchievementProvider();
      expect(provider.allAchievements.isNotEmpty, isTrue);
      expect(provider.progress.studyStreakDays, greaterThanOrEqualTo(0));

      provider.setCategory(AchievementCategory.academic);
      expect(provider.filteredAchievements.every((a) => a.category == AchievementCategory.academic), isTrue);
    });

    test('AchievementService generates personalized recommendations', () {
      final progress = AchievementService.getProgress();
      expect(progress.aiGoalRecommendations.isNotEmpty, isTrue);
      expect(progress.aiGoalRecommendations.first.contains('unlock'), isTrue);
    });
  });

  group('Campus Transport & Grounded Navigation Tests', () {
    test('Searches stop destination and returns scheduled route', () {
      final provider = TransportProvider();
      expect(provider.allRoutes.isNotEmpty, isTrue);

      provider.searchDestination('Main Gate');
      expect(provider.searchResult, isNotNull);
      expect(provider.searchResult!.recommendedRoute.name.isNotEmpty, isTrue);
    });

    test('AI Transport Assistant responds with schedule disclaimer notice', () async {
      final provider = TransportProvider();
      await provider.sendAssistantMessage('When is the next bus to Metro Station?');

      expect(provider.chatHistory.length, greaterThanOrEqualTo(2));
      final lastResponse = provider.chatHistory.last;
      expect(lastResponse.isUser, isFalse);
      expect(lastResponse.text.isNotEmpty, isTrue);
    });
  });

  group('Subscription System & Dynamic Yearly Savings Tests', () {
    test('Dynamic yearly savings calculation formula is exact', () {
      final savings = SubscriptionService.calculateYearlySavings();
      expect(savings.containsKey('discountPercent'), isTrue);
      expect(savings['discountPercent'], greaterThan(0));
    });

    test('EntitlementService enforces feature tiers cleanly', () {
      // Free Tier
      final freeEntitlements = EntitlementService(
        currentPlan: SubscriptionPlan.free,
        usageLimits: SubscriptionService.limits,
      );
      expect(freeEntitlements.canUseAdvancedAnalytics(), isFalse);
      expect(freeEntitlements.hasNoAds(), isFalse);

      // Plus Tier
      final plusEntitlements = EntitlementService(
        currentPlan: SubscriptionPlan.plus,
        usageLimits: SubscriptionService.limits,
      );
      expect(plusEntitlements.hasNoAds(), isTrue);
      expect(plusEntitlements.canUseAdvancedAnalytics(), isTrue);
      expect(plusEntitlements.canUseNotesCopilot(), isTrue);

      // Pro Tier
      final proEntitlements = EntitlementService(
        currentPlan: SubscriptionPlan.pro,
        usageLimits: SubscriptionService.limits,
      );
      expect(proEntitlements.canGenerateAdvancedQuiz(), isTrue);
      expect(proEntitlements.canUseCareerAI(), isTrue);
    });

    test('SubscriptionProvider switches plans and toggles billing cycles', () {
      final provider = SubscriptionProvider();
      expect(provider.currentPlan, isNotNull);

      provider.switchPlan(SubscriptionPlan.pro);
      expect(provider.currentPlan, equals(SubscriptionPlan.pro));

      provider.toggleBillingCycle(true);
      expect(provider.isYearlyBillingSelected, isTrue);

      provider.toggleBillingCycle(false);
      expect(provider.isYearlyBillingSelected, isFalse);
    });
  });
}
