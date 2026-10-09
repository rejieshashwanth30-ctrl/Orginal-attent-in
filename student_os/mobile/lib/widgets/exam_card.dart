import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/date_extensions.dart';
import '../models/exam.dart';
import 'app_card.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onTap;
  final VoidCallback? onSyllabusTap;

  const ExamCard({
    super.key,
    required this.exam,
    this.onTap,
    this.onSyllabusTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Color badgeColor;
    switch (exam.type) {
      case 'SEMESTER':
        badgeColor = colors.danger;
        break;
      case 'MODEL':
        badgeColor = colors.warning;
        break;
      case 'LAB':
        badgeColor = colors.secondary;
        break;
      default:
        badgeColor = colors.primary;
    }

    final isUrgent = exam.daysRemaining >= 0 && exam.daysRemaining <= 3;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      border: isUrgent
          ? BorderSide(color: colors.danger.withValues(alpha: 0.5), width: 1.4)
          : null,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        exam.type,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Max: ${exam.maxMarks} Marks',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? colors.danger.withValues(alpha: 0.15)
                      : colors.elevatedCard,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exam.countdownText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isUrgent
                        ? colors.danger
                        : colors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            exam.subjectName,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 13, color: colors.mutedText),
                  const SizedBox(width: 4),
                  Text(
                    exam.date.toFormattedDate(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 13, color: colors.mutedText),
                  const SizedBox(width: 4),
                  Text(
                    '${exam.startTime} - ${exam.endTime}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 13, color: colors.mutedText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  exam.room,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          if (exam.syllabus != null && exam.syllabus!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.elevatedCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Syllabus: ${exam.syllabus}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.secondaryText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
