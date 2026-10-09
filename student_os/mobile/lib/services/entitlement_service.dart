import '../models/subscription_models.dart';

class EntitlementService {
  final SubscriptionPlan currentPlan;
  final AIUsageLimits usageLimits;

  EntitlementService({
    required this.currentPlan,
    required this.usageLimits,
  });

  bool get isPaid => currentPlan != SubscriptionPlan.free;
  bool get isPro => currentPlan == SubscriptionPlan.pro;
  bool get isPlusOrYearly => currentPlan == SubscriptionPlan.plus || currentPlan == SubscriptionPlan.yearly;

  bool canUseNotesCopilot() {
    return isPaid; // Pro, Plus, Yearly
  }

  bool canUseAdaptiveQuiz() {
    return isPlusOrYearly; // Plus, Yearly
  }

  bool canGenerateAdvancedQuiz() {
    return isPaid;
  }

  bool canUseCareerAI() {
    return isPaid;
  }

  bool canUseAdvancedAnalytics() {
    return isPlusOrYearly;
  }

  bool canAccessAiStudyCoach() {
    return isPlusOrYearly;
  }

  bool hasNoAds() {
    return isPaid;
  }

  bool canGenerateQuiz() {
    if (isPlusOrYearly) return true;
    return usageLimits.quizzesRemaining > 0;
  }

  bool canGenerateFlashcards() {
    if (isPlusOrYearly) return true;
    return usageLimits.flashcardsRemaining > 0;
  }

  int get monthlyQuizLimit {
    switch (currentPlan) {
      case SubscriptionPlan.free:
        return 5;
      case SubscriptionPlan.pro:
        return 50;
      case SubscriptionPlan.plus:
      case SubscriptionPlan.yearly:
        return 500;
    }
  }

  int get monthlyFlashcardLimit {
    switch (currentPlan) {
      case SubscriptionPlan.free:
        return 10;
      case SubscriptionPlan.pro:
        return 100;
      case SubscriptionPlan.plus:
      case SubscriptionPlan.yearly:
        return 1000;
    }
  }

  int get monthlyCopilotLimit {
    switch (currentPlan) {
      case SubscriptionPlan.free:
        return 15;
      case SubscriptionPlan.pro:
        return 150;
      case SubscriptionPlan.plus:
      case SubscriptionPlan.yearly:
        return 2000;
    }
  }
}
