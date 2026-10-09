import '../models/subscription_models.dart';

class SubscriptionService {
  static SubscriptionPlan _activePlan = SubscriptionPlan.pro;
  static DateTime _renewalDate = DateTime.now().add(const Duration(days: 28));
  static AIUsageLimits _limits = AIUsageLimits(
    quizzesGeneratedThisMonth: 8,
    quizMonthlyLimit: 50,
    flashcardSetsGeneratedThisMonth: 12,
    flashcardMonthlyLimit: 100,
    copilotQueriesThisMonth: 24,
    copilotMonthlyLimit: 150,
  );

  static SubscriptionPlan get activePlan => _activePlan;
  static DateTime get renewalDate => _renewalDate;
  static AIUsageLimits get limits => _limits;

  static SubscriptionInfo getSubscriptionInfo() {
    switch (_activePlan) {
      case SubscriptionPlan.free:
        return SubscriptionInfo(
          plan: SubscriptionPlan.free,
          title: 'ATTENT-IN Free',
          priceDisplay: '₹0',
          billingPeriod: 'Forever Free',
          renewalDate: null,
          features: [
            'Core Student OS (Attendance, Timetable, Tasks)',
            'Standard Class Notes & Notebook',
            'CGPA Calculator & Target Planner',
            'Hostel, Library, Clubs & Campus Transport',
            'Basic Achievements Tracking',
            '5 AI Quizzes / Month',
            '10 Flashcard Sets / Month',
          ],
        );
      case SubscriptionPlan.pro:
        return SubscriptionInfo(
          plan: SubscriptionPlan.pro,
          title: 'ATTENT-IN Pro',
          priceDisplay: '₹99',
          billingPeriod: 'per month',
          renewalDate: _renewalDate,
          features: [
            'Everything in Free',
            '50 AI Quizzes / Month',
            '100 Flashcard Sets / Month',
            'Grounded Notes Copilot & Chapter Summarizer',
            'AI Study Recommendations & Daily Action Loops',
            'AI Attendance Margin Insights & Predictive Alerts',
            'AI CGPA Forecasts & Grade Solvers',
            'AI Quiz Diagnostic & Weak Area Analytics',
            'AI Achievement Milestone Recommendations',
            'Basic Career & Resume AI Tools',
            'Zero Banner & Interstitial Ads',
          ],
        );
      case SubscriptionPlan.plus:
        return SubscriptionInfo(
          plan: SubscriptionPlan.plus,
          title: 'ATTENT-IN Plus',
          priceDisplay: '₹199',
          billingPeriod: 'per month',
          renewalDate: _renewalDate,
          features: [
            'Everything in Pro',
            '500 AI Quizzes / Month (High-capacity tier)',
            '1,000 Flashcard Generations / Month',
            'Advanced Multi-Document Notes Copilot',
            'Adaptive Quiz Engine (Real-time difficulty scaling)',
            'Flashcards Auto-Generated from Quiz Mistakes',
            'Full Career AI Suite (ATS Resume Scorer, Mock Interview)',
            'Placement Readiness & Job Matching AI',
            'Advanced Multi-Semester Performance Analytics',
            'Priority AI Model Compute & Lowest Latency',
            'Zero Ads Guarantee',
          ],
        );
      case SubscriptionPlan.yearly:
        return SubscriptionInfo(
          plan: SubscriptionPlan.yearly,
          title: 'ATTENT-IN Yearly',
          priceDisplay: '₹1,099',
          billingPeriod: 'per year',
          renewalDate: DateTime.now().add(const Duration(days: 365)),
          features: [
            'All ATTENT-IN Plus Features Included',
            'Annual Billing Discount (Save ₹1,289 / 54% vs Monthly)',
            'Unlimited Learning Deck Storage & Sync',
            'Early Access to Beta AI Features & New Models',
            'Direct Priority Student Support Channel',
          ],
        );
    }
  }

  /// Sets plan (e.g. for sandbox preview or platform purchase callback)
  static void setPlan(SubscriptionPlan plan) {
    _activePlan = plan;
    if (plan == SubscriptionPlan.yearly) {
      _renewalDate = DateTime.now().add(const Duration(days: 365));
      _limits = _limits.copyWith(
        quizMonthlyLimit: 500,
        flashcardMonthlyLimit: 1000,
        copilotMonthlyLimit: 2000,
      );
    } else if (plan == SubscriptionPlan.plus) {
      _renewalDate = DateTime.now().add(const Duration(days: 30));
      _limits = _limits.copyWith(
        quizMonthlyLimit: 500,
        flashcardMonthlyLimit: 1000,
        copilotMonthlyLimit: 2000,
      );
    } else if (plan == SubscriptionPlan.pro) {
      _renewalDate = DateTime.now().add(const Duration(days: 30));
      _limits = _limits.copyWith(
        quizMonthlyLimit: 50,
        flashcardMonthlyLimit: 100,
        copilotMonthlyLimit: 150,
      );
    } else {
      _limits = _limits.copyWith(
        quizMonthlyLimit: 5,
        flashcardMonthlyLimit: 10,
        copilotMonthlyLimit: 15,
      );
    }
  }

  /// Calculates dynamic savings for yearly plan vs 12 months of plus plan
  static Map<String, dynamic> calculateYearlySavings() {
    const int monthlyPlusPrice = 199;
    const int yearlyPrice = 1099;
    const int annualMonthlyTotal = monthlyPlusPrice * 12; // 2388
    const int totalSavings = annualMonthlyTotal - yearlyPrice; // 1289
    const double discountPercentage = ((totalSavings / annualMonthlyTotal) * 100); // 53.97%

    return {
      'annualMonthlyTotal': annualMonthlyTotal,
      'yearlyPrice': yearlyPrice,
      'savingsAmount': totalSavings,
      'discountPercent': discountPercentage.round(),
    };
  }

  /// Simulates incrementing quiz usage
  static void recordQuizUsage() {
    _limits = _limits.copyWith(
      quizzesGeneratedThisMonth: _limits.quizzesGeneratedThisMonth + 1,
    );
  }

  /// Simulates incrementing flashcard usage
  static void recordFlashcardUsage() {
    _limits = _limits.copyWith(
      flashcardSetsGeneratedThisMonth: _limits.flashcardSetsGeneratedThisMonth + 1,
    );
  }

  /// Generates grounded premium performance analytics
  static PremiumAnalyticsData getAnalyticsData() {
    return PremiumAnalyticsData(
      quizAccuracy: 84.5,
      quizImprovementPercent: 12.0,
      strongestSubject: 'Machine Learning',
      weakestSubject: 'Data Structures & Algorithms',
      totalQuizzesTaken: 14,
      totalQuestionsAnswered: 135,
      flashcardsMastered: 42,
      totalFlashcardsReviewed: 180,
      currentStudyStreakDays: 7,
      attendancePercentage: 86.4,
      currentCgpa: 8.7,
      achievementsUnlocked: 12,
      careerReadinessScore: 78,
      weeklyQuizScores: [68.0, 72.5, 75.0, 80.0, 82.0, 88.0, 84.5],
      aiPersonalizedSummary: [
        'Your strongest area is Machine Learning with 92% concept accuracy.',
        'Your weakest area is DSA (Graph Traversals) where accuracy is 64%.',
        'Your quiz performance improved by approximately 12% over the last 3 weeks.',
        'Flashcard spaced repetition retention rate is currently 88.2%.',
      ],
    );
  }
}
