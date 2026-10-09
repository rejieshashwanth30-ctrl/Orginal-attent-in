import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../models/attendance.dart';
import 'app_card.dart';

class AttendanceCard extends StatelessWidget {
  final SubjectAttendance subjectAttendance;
  final VoidCallback? onMarkAttendance;
  final VoidCallback? onTap;

  const AttendanceCard({
    super.key,
    required this.subjectAttendance,
    this.onMarkAttendance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pct = subjectAttendance.percentage;
    final isLow = pct < 75.0;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.elevatedCard,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.border, width: 0.8),
                          ),
                          child: Text(
                            subjectAttendance.subjectCode,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        if (isLow) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: colors.warning.withValues(alpha: 0.5), width: 0.8),
                            ),
                            child: Text(
                              'SHORTAGE',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: colors.warning,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subjectAttendance.subjectName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.primaryText,
                      ),
                    ),
                    if (subjectAttendance.faculty != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subjectAttendance.faculty!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Percentage pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isLow ? colors.warning.withValues(alpha: 0.15) : colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLow ? colors.warning.withValues(alpha: 0.5) : colors.primary.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${pct.toStringAsFixed(0)}%',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isLow ? colors.warning : colors.primary,
                      ),
                    ),
                    Text(
                      isLow ? 'Shortage' : 'Safe',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isLow ? colors.warning : colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct / 100.0,
              minHeight: 6,
              backgroundColor: colors.elevatedCard,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLow ? colors.warning : colors.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Attended: ${subjectAttendance.attendedClasses}/${subjectAttendance.totalClasses} classes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isLow
                    ? 'Need ${subjectAttendance.classesNeeded} more'
                    : 'Can miss ${subjectAttendance.classesCanMiss}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isLow ? colors.warning : colors.secondaryText,
                ),
              ),
            ],
          ),
          if (onMarkAttendance != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton.icon(
                onPressed: onMarkAttendance,
                icon: const Icon(Icons.add_task_outlined, size: 16),
                label: Text(
                  'Mark Attendance',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  backgroundColor: colors.card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: colors.border),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
