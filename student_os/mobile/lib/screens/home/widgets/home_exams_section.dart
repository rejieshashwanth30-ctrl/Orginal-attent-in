import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/exam.dart';
import '../../../services/mock_data_service.dart';

class HomeExamsSection extends StatelessWidget {
  const HomeExamsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final upcomingExams = MockDataService.exams.take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 14,
                      color: colors.warning,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'UPCOMING EXAMS & TESTS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: colors.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => context.push('/exams'),
                child: Text(
                  'Full Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (upcomingExams.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border, width: 1),
                boxShadow: [colors.cardShadow],
              ),
              child: Center(
                child: Text(
                  'No upcoming exams in the next 30 days.',
                  style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingExams.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final exam = upcomingExams[index];
                return _buildExamCard(context, exam);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, Exam exam) {
    final colors = AppColors.of(context);
    final daysLeft = exam.date.difference(DateTime.now()).inDays;
    final countdownText = daysLeft <= 0 ? 'Today' : (daysLeft == 1 ? 'Tomorrow' : '$daysLeft days left');
    final formattedDate = DateFormat('EEE, MMM d').format(exam.date);

    return InkWell(
      onTap: () => context.push('/exams'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 1),
          boxShadow: [
            colors.cardShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Type Badge + Countdown Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.border, width: 0.8),
                  ),
                  child: Text(
                    exam.type,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colors.warning.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alarm_rounded, size: 12, color: colors.warning),
                      const SizedBox(width: 4),
                      Text(
                        countdownText,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Subject Name
            Text(
              exam.subjectName,
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 4),

            // Details: Date, Time, Room
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 12, color: colors.mutedText),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    formattedDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time_rounded, size: 12, color: colors.mutedText),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    exam.startTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                  ),
                ),
                if (exam.room.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.room_outlined, size: 12, color: colors.mutedText),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      exam.room,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
