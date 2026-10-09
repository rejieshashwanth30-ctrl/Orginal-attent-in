import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/assignment.dart';
import '../../../services/mock_data_service.dart';

class HomeTasksSection extends StatelessWidget {
  const HomeTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Get top pending assignments
    final pendingAssignments = MockDataService.assignments
        .where((a) => a.status != 'COMPLETED')
        .take(3)
        .toList();

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
                      Icons.assignment_outlined,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'PRIORITY ASSIGNMENTS & TASKS',
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
                onTap: () => context.push('/assignments'),
                child: Text(
                  'View All (${MockDataService.assignments.length})',
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

          if (pendingAssignments.isEmpty)
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
                  'All assignments completed! Great job.',
                  style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingAssignments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final asgn = pendingAssignments[index];
                return _buildAssignmentTile(context, asgn);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAssignmentTile(BuildContext context, Assignment asgn) {
    final colors = AppColors.of(context);
    final isHigh = asgn.priority == 'HIGH';
    final priorityColor = isHigh ? colors.danger : (asgn.priority == 'MEDIUM' ? colors.warning : colors.success);
    final dueFormatted = DateFormat('MMM d, h:mm a').format(asgn.dueDate);

    return InkWell(
      onTap: () => context.push('/assignments'),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Status Pill
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: priorityColor.withValues(alpha: 0.4), width: 1),
              ),
              child: Center(
                child: Icon(
                  isHigh ? Icons.warning_amber_rounded : Icons.assignment_outlined,
                  size: 18,
                  color: priorityColor,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Middle: Title & Subject
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asgn.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          asgn.subject?.name ?? 'Coursework',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('•', style: TextStyle(color: colors.mutedText, fontSize: 10)),
                      const SizedBox(width: 6),
                      Text(
                        'Due $dueFormatted',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isHigh ? colors.warning : colors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Right Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                asgn.priority,
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: priorityColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
