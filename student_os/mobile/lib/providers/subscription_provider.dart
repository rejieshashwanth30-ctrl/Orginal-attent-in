import 'package:flutter/material.dart';
import '../models/subscription_models.dart';
import '../services/entitlement_service.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlan _currentPlan = SubscriptionService.activePlan;
  bool _isYearlyBillingSelected = true;

  SubscriptionPlan get currentPlan => _currentPlan;
  bool get isYearlyBillingSelected => _isYearlyBillingSelected;

  SubscriptionInfo get subscriptionInfo => SubscriptionService.getSubscriptionInfo();
  AIUsageLimits get usageLimits => SubscriptionService.limits;
  PremiumAnalyticsData get analyticsData => SubscriptionService.getAnalyticsData();

  EntitlementService get entitlements => EntitlementService(
        currentPlan: _currentPlan,
        usageLimits: usageLimits,
      );

  Map<String, dynamic> get yearlySavings => SubscriptionService.calculateYearlySavings();

  void toggleBillingCycle(bool isYearly) {
    _isYearlyBillingSelected = isYearly;
    notifyListeners();
  }

  void switchPlan(SubscriptionPlan plan) {
    _currentPlan = plan;
    SubscriptionService.setPlan(plan);
    notifyListeners();
  }
}
