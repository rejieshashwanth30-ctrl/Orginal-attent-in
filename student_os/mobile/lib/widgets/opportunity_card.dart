import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import 'app_button.dart';
import 'app_card.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? tag;
  final Color tagColor;
  final String highlight; // e.g. "Prize: ₹1,00,000", "Stipend: ₹80,000/mo"
  final List<String> skills;
  final String description;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String secondaryButtonText;

  const OpportunityCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.tag,
    this.tagColor = AppColors.primary,
    required this.highlight,
    this.skills = const [],
    required this.description,
    this.primaryButtonText = 'Apply Now',
    required this.onPrimaryAction,
    this.onSecondaryAction,
    this.secondaryButtonText = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tag != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: tagColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.primaryText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  highlight,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colors.secondaryText,
            ),
          ),
          if (skills.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: skills.take(4).map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: colors.secondaryText,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (onSecondaryAction != null) ...[
                Expanded(
                  flex: 1,
                  child: AppButton(
                    text: secondaryButtonText,
                    type: AppButtonType.secondary,
                    height: 38,
                    onPressed: onSecondaryAction!,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                flex: 2,
                child: AppButton(
                  text: primaryButtonText,
                  type: AppButtonType.primary,
                  height: 38,
                  onPressed: onPrimaryAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
