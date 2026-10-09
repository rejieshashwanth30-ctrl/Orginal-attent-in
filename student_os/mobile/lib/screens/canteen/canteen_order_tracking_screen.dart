import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/canteen_provider.dart';
import 'widgets/order_status_timeline.dart';

class CanteenOrderTrackingScreen extends StatelessWidget {
  const CanteenOrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();

    // Retrieve active tracking order or first available order
    final order = canteenProvider.activeTrackingOrder ??
        (canteenProvider.allOrders.isNotEmpty ? canteenProvider.allOrders.first : null);

    if (order == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('Order Tracking')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 50, color: colors.mutedText),
              const SizedBox(height: 12),
              Text(
                'No active order to track',
                style: GoogleFonts.outfit(fontSize: 16, color: colors.primaryText),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/canteen'),
                child: const Text('Go to Canteen'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/canteen/orders');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Order Tracking',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              '${order.orderNumber} • Token ${order.tokenNumber}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, size: 20),
            tooltip: 'All Orders',
            onPressed: () => context.push('/canteen/orders'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // 1. Big Highlight Token Card
            _buildTokenDisplayCard(order, colors),

            const SizedBox(height: 18),

            // 2. 4-Stage Status Progress Timeline
            OrderStatusTimeline(currentStatus: order.status),

            const SizedBox(height: 18),

            // 3. Counter Pickup Guidance Card
            _buildPickupLocationCard(order, colors),

            const SizedBox(height: 18),

            // 4. Ordered Items Breakdown
            _buildOrderedItemsCard(order, colors),

            const SizedBox(height: 20),

            // 5. Prototype Simulation Controls
            _buildPrototypeSimulatorSection(context, order, canteenProvider, colors),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenDisplayCard(CanteenOrder order, AppColorPalette colors) {
    final isReady = order.status == OrderStatus.readyForPickup;
    final isCollected = order.status == OrderStatus.collected;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isReady
              ? [colors.success.withValues(alpha: 0.15), colors.success.withValues(alpha: 0.05)]
              : [colors.primary.withValues(alpha: 0.12), colors.accentCyan.withValues(alpha: 0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isReady ? colors.success.withValues(alpha: 0.4) : colors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOKEN NUMBER',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: isReady ? colors.success : colors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.tokenNumber,
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Icon(
                      isCollected
                          ? Icons.check_circle_outline_rounded
                          : (isReady ? Icons.shopping_bag_outlined : Icons.timer_outlined),
                      size: 20,
                      color: isReady ? colors.success : colors.primary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isCollected
                          ? 'COLLECTED'
                          : (isReady ? 'READY NOW' : 'EST. 6 MINS'),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isReady ? colors.success : colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code_2_rounded, size: 20, color: colors.secondaryText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Show this token code at the counter for contactless handover',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: colors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupLocationCard(CanteenOrder order, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'PICKUP LOCATION & TIME',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: colors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.canteenName,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${order.canteenLocation} • ${order.counterInfo}',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: colors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Slot: ${order.pickupSlot.label} (${order.pickupSlot.timeRange})',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderedItemsCard(CanteenOrder order, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant_menu_rounded, size: 16, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'ORDER SUMMARY',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),
              Text(
                '${order.totalItemsCount} items',
                style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.foodItem.emoji} ${item.foodItem.name}',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: colors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
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
          if (order.specialInstructions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes_rounded, size: 14, color: colors.secondaryText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Note: ${order.specialInstructions}',
                      style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrototypeSimulatorSection(
    BuildContext context,
    CanteenOrder order,
    CanteenProvider provider,
    AppColorPalette colors,
  ) {
    final canAdvance = order.status != OrderStatus.collected && order.status != OrderStatus.cancelled;
    final canCancel = order.status == OrderStatus.placed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science_outlined, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'PROTOTYPE DEMO CONTROLS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Simulate kitchen & pickup progress in real-time without a live backend connection.',
            style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (canAdvance)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      provider.advanceOrderStage(order.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order advanced to: ${order.status.displayName}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.fast_forward_rounded, size: 16),
                    label: const Text('Simulate Next Stage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              if (canCancel) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    provider.cancelOrder(order.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order cancelled.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.danger,
                    side: BorderSide(color: colors.danger.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
