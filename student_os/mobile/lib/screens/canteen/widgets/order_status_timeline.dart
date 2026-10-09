import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final steps = [
      {'title': 'Order Placed', 'icon': Icons.receipt_long_rounded, 'desc': 'Kitchen received ticket'},
      {'title': 'Preparing', 'icon': Icons.soup_kitchen_rounded, 'desc': 'Chef cooking & packing'},
      {'title': 'Ready for Pickup', 'icon': Icons.shopping_bag_rounded, 'desc': 'Waiting at express counter'},
      {'title': 'Collected', 'icon': Icons.check_circle_rounded, 'desc': 'Meal received by student'},
    ];

    final currentIdx = currentStatus.stepIndex;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colors.isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.timeline_rounded, size: 16, color: colors.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'LIVE STATUS TRACKER',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: colors.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusBadgeColor(currentStatus, colors).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentStatus.displayName.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _getStatusBadgeColor(currentStatus, colors),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 4-Step Vertical Timeline with connector line
          ...List.generate(steps.length, (index) {
            final isCompleted = index <= currentIdx;
            final isCurrent = index == currentIdx;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator & Connector Line
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? (isCurrent ? colors.primary : colors.success)
                            : colors.surface,
                        border: Border.all(
                          color: isCompleted
                              ? (isCurrent ? colors.primary : colors.success)
                              : colors.border,
                          width: 2,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        steps[index]['icon'] as IconData,
                        size: 16,
                        color: isCompleted ? Colors.white : colors.mutedText,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: index < currentIdx ? colors.success : colors.border,
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Step Text Description
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              steps[index]['title'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 14.5,
                                fontWeight: isCurrent ? FontWeight.w700 : (isCompleted ? FontWeight.w600 : FontWeight.w500),
                                color: isCompleted ? colors.primaryText : colors.mutedText,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[index]['desc'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: isCurrent ? colors.primary : colors.secondaryText,
                            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _getStatusBadgeColor(OrderStatus status, AppColorPalette colors) {
    switch (status) {
      case OrderStatus.placed:
        return const Color(0xFF3B82F6);
      case OrderStatus.preparing:
        return const Color(0xFFF59E0B);
      case OrderStatus.readyForPickup:
        return const Color(0xFF10B981);
      case OrderStatus.collected:
        return const Color(0xFF6B7280);
      case OrderStatus.cancelled:
        return colors.danger;
    }
  }
}
