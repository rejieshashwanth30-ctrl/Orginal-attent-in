import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../app_button.dart';

class PremiumUpgradeDialog extends StatelessWidget {
  final String featureName;
  final String description;

  const PremiumUpgradeDialog({
    super.key,
    required this.featureName,
    this.description = 'This feature is available with ATTENT-IN Pro and Plus subscriptions.',
  });

  static Future<void> show(
    BuildContext context, {
    required String featureName,
    String? description,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PremiumUpgradeDialog(
        featureName: featureName,
        description: description ?? 'This feature is available with ATTENT-IN Pro and Plus subscriptions.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
          boxShadow: [
            colors.cardShadow,
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 26),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Text(
              'ATTENT-IN PREMIUM',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 8),

            // Feature Callout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: colors.elevatedCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Text(
                '$featureName requires Pro / Plus',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: colors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Bullet List of Unlocks
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.elevatedCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Column(
                children: [
                  _buildUnlockItem('✓ Advanced AI Quiz & Adaptive Scaling', colors.secondaryText),
                  const SizedBox(height: 8),
                  _buildUnlockItem('✓ Multi-Deck AI Flashcards & Review Sync', colors.secondaryText),
                  const SizedBox(height: 8),
                  _buildUnlockItem('✓ Notes Copilot Document Intelligence', colors.secondaryText),
                  const SizedBox(height: 8),
                  _buildUnlockItem('✓ Advanced Analytics & Study Telemetry', colors.secondaryText),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            AppButton(
              text: 'View Plans & Upgrade',
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/premium');
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Maybe Later',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.mutedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockItem(String text, Color textColor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
