enum SubscriptionPlan {
  free,
  pro,
  plus,
  yearly,
}

class SubscriptionInfo {
  final SubscriptionPlan plan;
  final String title;
  final String priceDisplay;
  final String billingPeriod;
  final bool isActive;
  final DateTime? renewalDate;
  final List<String> features;

  SubscriptionInfo({
    required this.plan,
    required this.title,
    required this.priceDisplay,
    required this.billingPeriod,
    this.isActive = true,
    this.renewalDate,
    required this.features,
  });

  bool get isPaid => plan != SubscriptionPlan.free;
  bool get isPro => plan == SubscriptionPlan.pro;
  bool get isPlusOrYearly => plan == SubscriptionPlan.plus || plan == SubscriptionPlan.yearly;
}

class AIUsageLimits {
  final int quizzesGeneratedThisMonth;
  final int quizMonthlyLimit;
  final int flashcardSetsGeneratedThisMonth;
  final int flashcardMonthlyLimit;
  final int copilotQueriesThisMonth;
  final int copilotMonthlyLimit;

  AIUsageLimits({
    this.quizzesGeneratedThisMonth = 2,
    this.quizMonthlyLimit = 5,
    this.flashcardSetsGeneratedThisMonth = 3,
    this.flashcardMonthlyLimit = 10,
    this.copilotQueriesThisMonth = 4,
    this.copilotMonthlyLimit = 15,
  });

  int get quizzesRemaining => (quizMonthlyLimit - quizzesGeneratedThisMonth).clamp(0, 9999);
  int get flashcardsRemaining => (flashcardMonthlyLimit - flashcardSetsGeneratedThisMonth).clamp(0, 9999);
  int get copilotRemaining => (copilotMonthlyLimit - copilotQueriesThisMonth).clamp(0, 9999);

  AIUsageLimits copyWith({
    int? quizzesGeneratedThisMonth,
    int? quizMonthlyLimit,
    int? flashcardSetsGeneratedThisMonth,
    int? flashcardMonthlyLimit,
    int? copilotQueriesThisMonth,
    int? copilotMonthlyLimit,
  }) {
    return AIUsageLimits(
      quizzesGeneratedThisMonth: quizzesGeneratedThisMonth ?? this.quizzesGeneratedThisMonth,
      quizMonthlyLimit: quizMonthlyLimit ?? this.quizMonthlyLimit,
      flashcardSetsGeneratedThisMonth: flashcardSetsGeneratedThisMonth ?? this.flashcardSetsGeneratedThisMonth,
      flashcardMonthlyLimit: flashcardMonthlyLimit ?? this.flashcardMonthlyLimit,
      copilotQueriesThisMonth: copilotQueriesThisMonth ?? this.copilotQueriesThisMonth,
      copilotMonthlyLimit: copilotMonthlyLimit ?? this.copilotMonthlyLimit,
    );
  }
}

class PremiumAnalyticsData {
  final double quizAccuracy;
  final double quizImprovementPercent;
  final String strongestSubject;
  final String weakestSubject;
  final int totalQuizzesTaken;
  final int totalQuestionsAnswered;
  final int flashcardsMastered;
  final int totalFlashcardsReviewed;
  final int currentStudyStreakDays;
  final double attendancePercentage;
  final double currentCgpa;
  final int achievementsUnlocked;
  final int careerReadinessScore;
  final List<double> weeklyQuizScores;
  final List<String> aiPersonalizedSummary;

  PremiumAnalyticsData({
    required this.quizAccuracy,
    required this.quizImprovementPercent,
    required this.strongestSubject,
    required this.weakestSubject,
    required this.totalQuizzesTaken,
    required this.totalQuestionsAnswered,
    required this.flashcardsMastered,
    required this.totalFlashcardsReviewed,
    required this.currentStudyStreakDays,
    required this.attendancePercentage,
    required this.currentCgpa,
    required this.achievementsUnlocked,
    required this.careerReadinessScore,
    required this.weeklyQuizScores,
    required this.aiPersonalizedSummary,
  });
}
