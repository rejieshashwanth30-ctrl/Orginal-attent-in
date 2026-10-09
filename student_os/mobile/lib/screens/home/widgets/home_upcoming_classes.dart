import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/timetable.dart';
import '../../../services/mock_data_service.dart';

class HomeUpcomingClasses extends StatelessWidget {
  const HomeUpcomingClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Fetch today's schedule from MockDataService
    final now = DateTime.now();
    final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final todayName = weekdayNames[now.weekday - 1];
    final todayClasses = MockDataService.timetable[todayName] ?? MockDataService.timetable['Monday'] ?? [];

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
                      Icons.schedule_rounded,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "TODAY'S CLASSES",
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
                onTap: () => context.push('/timetable'),
                child: Text(
                  'Full Timetable',
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

          if (todayClasses.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border, width: 1),
                boxShadow: [colors.cardShadow],
              ),
              child: Center(
                child: Text(
                  'No scheduled classes for today! Self-study session.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: colors.secondaryText,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: todayClasses.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final slot = todayClasses[index];
                  final isFirst = index == 0;

                  return _buildClassCard(context, slot, isFirst);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, TimetableSlot slot, bool isCurrent) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: () => context.push('/timetable'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? colors.primary : colors.border,
            width: isCurrent ? 1.2 : 1,
          ),
          boxShadow: [
            colors.cardShadow,
            if (isCurrent)
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Code + Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.border, width: 0.8),
                  ),
                  child: Text(
                    slot.subjectCode,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.subtleAccentBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'NEXT UP',
                      style: GoogleFonts.inter(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Text(
                    slot.startTime,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.mutedText,
                    ),
                  ),
              ],
            ),

            // Subject Name
            Text(
              slot.subjectName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
              ),
            ),

            // Location & Timing
            Row(
              children: [
                Icon(Icons.room_outlined, size: 12, color: colors.mutedText),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    slot.room,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 10.5, color: colors.secondaryText),
                  ),
                ),
                const SizedBox(width: 6),
                Text('•', style: TextStyle(color: colors.mutedText, fontSize: 10)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${slot.startTime} - ${slot.endTime}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 10, color: colors.secondaryText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
