import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/canteen_provider.dart';

class CanteenOrderSuccessScreen extends StatelessWidget {
  const CanteenOrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();
    final order = canteenProvider.activeTrackingOrder ??
        (canteenProvider.allOrders.isNotEmpty ? canteenProvider.allOrders.first : null);

    if (order == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/canteen'),
            child: const Text('Return to Canteens'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // 1. Success Animation Icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.success.withValues(alpha: 0.3), width: 2),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 48,
                  color: colors.success,
                ),
              ),

              const SizedBox(height: 18),

              // 2. Success Heading
              Text(
                '🎉 Order Confirmed!',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your meal is scheduled and sent to the kitchen',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.secondaryText,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Prominent Token Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary.withValues(alpha: 0.12),
                      colors.accentCyan.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.primary.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'YOUR PICKUP TOKEN',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.tokenNumber,
                      style: GoogleFonts.outfit(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Order ID: ${order.orderNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: colors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Order Details Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.borderSubtle, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.restaurant_rounded,
                      title: 'Canteen',
                      value: order.canteenName,
                      colors: colors,
                    ),
                    const Divider(height: 18),
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Pickup Counter',
                      value: order.counterInfo,
                      colors: colors,
                    ),
                    const Divider(height: 18),
                    _buildInfoRow(
                      icon: Icons.schedule_rounded,
                      title: 'Scheduled Pickup Slot',
                      value: '${order.pickupSlot.label} (${order.pickupSlot.timeRange})',
                      colors: colors,
                      isHighlight: true,
                    ),
                    const Divider(height: 18),
                    _buildInfoRow(
                      icon: Icons.info_outline_rounded,
                      title: 'Current Status',
                      value: order.status.displayName,
                      colors: colors,
                      statusColor: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Ordered Items Quick Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.borderSubtle, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDERED ITEMS (${order.items.length})',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.quantity}x  ${item.foodItem.emoji} ${item.foodItem.name}',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: colors.primaryText,
                              ),
                            ),
                            Text(
                              '₹${item.totalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: colors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Paid',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                        ),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 6. Action Buttons: Track Order & Return to Canteens
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    canteenProvider.setActiveTrackingOrder(order);
                    context.go('/canteen/order-tracking');
                  },
                  icon: const Icon(Icons.timeline_rounded, size: 20),
                  label: Text(
                    'Track Live Order',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.go('/canteen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primaryText,
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Back to Campus Canteens',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required AppColorPalette colors,
    bool isHighlight = false,
    Color? statusColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.secondaryText),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: statusColor ?? (isHighlight ? colors.primary : colors.primaryText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
