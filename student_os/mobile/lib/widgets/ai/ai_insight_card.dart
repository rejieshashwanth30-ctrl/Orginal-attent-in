import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class AIInsightCard extends StatelessWidget {
  final String title;
  final String insight;
  final String? metricValue;
  final String? metricLabel;
  final String? riskLevel; // "LOW", "MEDIUM", "HIGH", "OPTIMAL"
  final Color? accentColor;
  final VoidCallback? onTap;
  final IconData? icon;

  const AIInsightCard({
    super.key,
    required this.title,
    required this.insight,
    this.metricValue,
    this.metricLabel,
    this.riskLevel,
    this.accentColor,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
        boxShadow: [
          colors.cardShadow,
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.elevatedCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.border, width: 0.8),
                            ),
                            child: Icon(
                              icon ?? Icons.auto_awesome,
                              size: 14,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                color: colors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (riskLevel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 0.8),
                        ),
                        child: Text(
                          riskLevel!.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  insight,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: colors.secondaryText,
                  ),
                ),
                if (metricValue != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.elevatedCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          metricValue!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                        if (metricLabel != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            metricLabel!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: colors.secondaryText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
