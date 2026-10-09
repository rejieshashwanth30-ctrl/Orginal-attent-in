import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../models/timetable.dart';
import 'app_card.dart';

class ClassScheduleCard extends StatelessWidget {
  final TimetableSlot slot;
  final bool isCurrentClass;
  final VoidCallback? onTap;

  const ClassScheduleCard({
    super.key,
    required this.slot,
    this.isCurrentClass = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Color parsedColor;
    try {
      final hex = slot.color.replaceFirst('#', '');
      parsedColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      parsedColor = colors.primary;
    }

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        border: isCurrentClass
            ? BorderSide(color: parsedColor, width: 1.8)
            : BorderSide(color: colors.border),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: parsedColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    slot.subjectCode,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: parsedColor,
                    ),
                  ),
                ),
                if (isCurrentClass)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE NOW',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: colors.success,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              slot.subjectName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 13, color: colors.mutedText),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    slot.room,
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
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 13, color: parsedColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${slot.startTime} - ${slot.endTime}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: parsedColor,
                    ),
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
