import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/subscription_models.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/app_card.dart';

class PremiumSubscriptionScreen extends StatelessWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final subProvider = context.watch<SubscriptionProvider>();
    final currentPlan = subProvider.currentPlan;
    final isYearly = subProvider.isYearlyBillingSelected;
    final savings = subProvider.yearlySavings;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('ATTENT-IN Premium'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined, color: colors.primary),
            tooltip: 'Premium Analytics',
            onPressed: () => context.push('/premium/analytics'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Crown Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.workspace_premium_rounded, size: 30, color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),

              // Title & Subtitle
              Text(
                'Unlock the Full ATTENT-IN Experience',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Study smarter. Stay organized. Supercharge your student OS.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.secondaryText,
                ),
              ),

              const SizedBox(height: 18),

              // Current Plan Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: currentPlan != SubscriptionPlan.free
                        ? colors.primary
                        : colors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentPlan != SubscriptionPlan.free ? Icons.verified_rounded : Icons.info_outline_rounded,
                      size: 16,
                      color: currentPlan != SubscriptionPlan.free ? colors.primary : colors.mutedText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current Plan: ${subProvider.subscriptionInfo.title}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryText,
                      ),
                    ),
                    if (subProvider.subscriptionInfo.renewalDate != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(Renews ${DateFormat('MMM d, yyyy').format(subProvider.subscriptionInfo.renewalDate!)})',
                        style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Billing Cycle Toggle (Monthly vs Yearly)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.elevatedCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleBtn(
                      label: 'Monthly Billing',
                      isSelected: !isYearly,
                      onTap: () => subProvider.toggleBillingCycle(false),
                      colors: colors,
                    ),
                    _buildToggleBtn(
                      label: 'Annual (Save ${savings['discountPercent']}%)',
                      isSelected: isYearly,
                      onTap: () => subProvider.toggleBillingCycle(true),
                      colors: colors,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. FREE PLAN
              _buildPlanCard(
                context: context,
                plan: SubscriptionPlan.free,
                title: 'FREE',
                price: '₹0',
                period: 'Forever free',
                badge: null,
                isCurrent: currentPlan == SubscriptionPlan.free,
                features: [
                  'Full Student OS (Attendance, Timetable, Tasks)',
                  'Standard Class Notes & Notebook',
                  'CGPA Calculator & Target Solver',
                  'Campus Transport & Bus Search',
                  'Hostel, Library & Clubs Modules',
                  '5 AI Quizzes / month',
                  '10 Flashcard sets / month',
                ],
                buttonText: currentPlan == SubscriptionPlan.free ? 'Current Active Plan' : 'Downgrade to Free',
                onSelect: () => subProvider.switchPlan(SubscriptionPlan.free),
                colors: colors,
              ),

              const SizedBox(height: 14),

              // 2. PRO PLAN
              _buildPlanCard(
                context: context,
                plan: SubscriptionPlan.pro,
                title: 'PRO',
                price: '₹99',
                period: 'per month',
                badge: 'POPULAR',
                isCurrent: currentPlan == SubscriptionPlan.pro,
                features: [
                  'Everything in Free',
                  '50 AI Quizzes & 100 Flashcards / month',
                  'Grounded Notes Copilot with Q&A',
                  'AI Study Recommendations & Learning Loops',
                  'AI Attendance & CGPA Predictive Forecasts',
                  'AI Quiz Diagnostics & Weak Area Analytics',
                  'AI Achievement Milestone Recommendations',
                  'Basic Career AI Assistance',
                  'Zero Banner Ads',
                ],
                buttonText: currentPlan == SubscriptionPlan.pro ? 'Current Active Plan' : 'Upgrade to Pro (₹99/mo)',
                onSelect: () => subProvider.switchPlan(SubscriptionPlan.pro),
                colors: colors,
              ),

              const SizedBox(height: 14),

              // 3. PLUS PLAN
              _buildPlanCard(
                context: context,
                plan: SubscriptionPlan.plus,
                title: 'PLUS',
                price: '₹199',
                period: 'per month',
                badge: 'POWER STUDENT',
                isCurrent: currentPlan == SubscriptionPlan.plus,
                features: [
                  'Everything in Pro',
                  '500 AI Quizzes & 1,000 Flashcard sets / month',
                  'Advanced Adaptive Quiz Engine (Dynamic scaling)',
                  'Auto-Generate Flashcards from Quiz Mistakes',
                  'Advanced Study Coach & Exam Simulator',
                  'Full Career AI Suite (ATS Resume Scorer & Interview AI)',
                  'Placement Readiness & Job Matching Engine',
                  'Multi-Semester Performance Analytics',
                  'Priority AI Processing & Lowest Latency',
                  'Zero Ads Guarantee',
                ],
                buttonText: currentPlan == SubscriptionPlan.plus ? 'Current Active Plan' : 'Upgrade to Plus (₹199/mo)',
                onSelect: () => subProvider.switchPlan(SubscriptionPlan.plus),
                colors: colors,
              ),

              const SizedBox(height: 14),

              // 4. YEARLY PLAN (Best Value with bright electric blue border & glowing CTA)
              _buildPlanCard(
                context: context,
                plan: SubscriptionPlan.yearly,
                title: 'YEARLY',
                price: '₹1,099',
                period: 'per year (Only ₹91/mo)',
                badge: 'BEST VALUE • SAVE ₹${savings['savingsAmount']}',
                isCurrent: currentPlan == SubscriptionPlan.yearly,
                isHighlight: true,
                features: [
                  'All Plus Features for 12 Months',
                  'Save ₹${savings['savingsAmount']} (54% Off Monthly Plus)',
                  'Unlimited Learning Decks & Offline Cache',
                  'Early Access to New AI Models & Features',
                  'Priority Direct Support Channel',
                ],
                buttonText: currentPlan == SubscriptionPlan.yearly ? 'Current Active Plan' : 'Get Yearly Best Value (₹1,099/yr)',
                onSelect: () => subProvider.switchPlan(SubscriptionPlan.yearly),
                colors: colors,
              ),

              const SizedBox(height: 24),

              // Feature Comparison Table
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FEATURE COMPARISON MATRIX', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primaryText)),
                    const SizedBox(height: 14),
                    _buildCompRow('Core Student OS', 'Free', 'Pro', 'Plus / Yearly', colors),
                    const Divider(height: 16),
                    _buildCompRow('AI Quizzes / mo', '5', '50', '500', colors),
                    const Divider(height: 16),
                    _buildCompRow('AI Flashcard sets', '10', '100', '1,000', colors),
                    const Divider(height: 16),
                    _buildCompRow('Notes Copilot', '—', '✓ Standard', '✓ Advanced', colors),
                    const Divider(height: 16),
                    _buildCompRow('Adaptive Quizzes', '—', '—', '✓ Included', colors),
                    const Divider(height: 16),
                    _buildCompRow('Career & Resume AI', '—', 'Basic', '✓ Full Suite', colors),
                    const Divider(height: 16),
                    _buildCompRow('Ad-Free Experience', 'Standard', '✓ No Ads', '✓ No Ads', colors),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Restore Purchases & Manage Subscription Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.restore_rounded, size: 16, color: colors.secondaryText),
                    label: Text('Restore Purchases', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checking store entitlements... Subscriptions restored successfully!')),
                      );
                    },
                  ),
                  Text(' • ', style: TextStyle(color: colors.mutedText)),
                  TextButton.icon(
                    icon: Icon(Icons.settings_suggest_outlined, size: 16, color: colors.secondaryText),
                    label: Text('Manage Subscription', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Google Play / App Store subscription manager...')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleBtn({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorPalette colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : colors.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required SubscriptionPlan plan,
    required String title,
    required String price,
    required String period,
    required String? badge,
    required bool isCurrent,
    bool isHighlight = false,
    required List<String> features,
    required String buttonText,
    required VoidCallback onSelect,
    required AppColorPalette colors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight || isCurrent ? colors.elevatedCard : colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight
              ? colors.primary
              : (isCurrent ? colors.primary : colors.border),
          width: isHighlight ? 1.8 : 1,
        ),
        boxShadow: isHighlight
            ? [
                colors.cardShadow,
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isHighlight ? colors.primary : colors.primaryText,
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isHighlight ? colors.primary.withValues(alpha: 0.15) : colors.elevatedCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isHighlight ? colors.primary : colors.border, width: 1),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Pricing Typography
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: colors.primaryText,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                period,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Features List
          ...features.map((f) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 15, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 18),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent
                    ? colors.card
                    : (isHighlight ? colors.primary : colors.elevatedCard),
                foregroundColor: isCurrent
                    ? colors.mutedText
                    : (isHighlight ? Colors.white : colors.primaryText),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCurrent
                      ? BorderSide.none
                      : BorderSide(color: isHighlight ? colors.primary : colors.border),
                ),
                elevation: 0,
              ),
              onPressed: isCurrent ? null : onSelect,
              child: Text(
                buttonText,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompRow(String feature, String freeVal, String proVal, String plusVal, AppColorPalette colors) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(feature, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: colors.primaryText)),
        ),
        Expanded(
          flex: 2,
          child: Text(freeVal, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10.5, color: colors.mutedText)),
        ),
        Expanded(
          flex: 2,
          child: Text(proVal, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10.5, color: colors.secondaryText, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(plusVal, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10.5, color: colors.primary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
