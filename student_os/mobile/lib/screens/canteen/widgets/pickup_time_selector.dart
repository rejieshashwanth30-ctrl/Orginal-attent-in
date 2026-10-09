import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../services/canteen_service.dart';

class PickupTimeSelector extends StatelessWidget {
  final PickupSlot selectedSlot;
  final TimeOfDay customTime;
  final ValueChanged<PickupSlot> onSelectSlot;
  final ValueChanged<TimeOfDay> onSelectCustomTime;

  const PickupTimeSelector({
    super.key,
    required this.selectedSlot,
    required this.customTime,
    required this.onSelectSlot,
    required this.onSelectCustomTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final slots = CanteenService.pickupSlots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule_rounded, size: 16, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'ORDER TYPE / PICKUP TIME',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: colors.primaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Pre-order now so your hot meal is ready right when the bell rings. Skip the canteen line!',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: colors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),

        // 3 Selectable Timing Cards
        ...slots.map((slot) {
          final isSelected = selectedSlot.type == slot.type;
          return _buildSlotCard(context, slot, isSelected, colors);
        }),

        // Custom Time Picker if selected
        if (selectedSlot.type == PickupSlotType.customTime) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Custom Pickup Time:',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimeOfDay(customTime),
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: customTime,
                    );
                    if (picked != null) {
                      onSelectCustomTime(picked);
                    }
                  },
                  icon: const Icon(Icons.edit_calendar_rounded, size: 15),
                  label: const Text('Change Time'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSlotCard(
    BuildContext context,
    PickupSlot slot,
    bool isSelected,
    AppColorPalette colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary.withValues(alpha: 0.08) : colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? colors.primary : colors.borderSubtle,
          width: isSelected ? 1.6 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => onSelectSlot(slot),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    slot.type.icon,
                    size: 20,
                    color: isSelected ? Colors.white : colors.primary,
                  ),
                ),
                const SizedBox(width: 14),

                // Label & Time Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            slot.label,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? colors.primary : colors.primaryText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withValues(alpha: 0.15)
                                  : colors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              slot.type == PickupSlotType.customTime
                                  ? _formatTimeOfDay(customTime)
                                  : slot.timeRange,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? colors.primary : colors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        slot.description,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Radio Indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.border,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isSelected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hourStr = tod.hourOfPeriod == 0 ? '12' : tod.hourOfPeriod.toString().padLeft(2, '0');
    final minStr = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hourStr:$minStr $period';
  }
}
