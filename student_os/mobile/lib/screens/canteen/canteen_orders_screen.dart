import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/canteen_provider.dart';

class CanteenOrdersScreen extends StatefulWidget {
  const CanteenOrdersScreen({super.key});

  @override
  State<CanteenOrdersScreen> createState() => _CanteenOrdersScreenState();
}

class _CanteenOrdersScreenState extends State<CanteenOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();

    final activeOrders = canteenProvider.activeOrders;
    final pastOrders = canteenProvider.pastOrders;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/canteen');
            }
          },
        ),
        title: Text(
          'My Canteen Orders',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.primaryText,
          ),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: colors.primary,
          labelColor: colors.primaryText,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Active Orders (${activeOrders.length})'),
            Tab(text: 'Past Orders (${pastOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // Tab 1: Active Orders
          _buildOrdersList(
            context,
            activeOrders,
            isActiveTab: true,
            canteenProvider: canteenProvider,
            colors: colors,
          ),

          // Tab 2: Past Orders
          _buildOrdersList(
            context,
            pastOrders,
            isActiveTab: false,
            canteenProvider: canteenProvider,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<CanteenOrder> orders, {
    required bool isActiveTab,
    required CanteenProvider canteenProvider,
    required AppColorPalette colors,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActiveTab ? Icons.pending_actions_rounded : Icons.history_rounded,
                size: 56,
                color: colors.mutedText,
              ),
              const SizedBox(height: 14),
              Text(
                isActiveTab ? 'No active pre-orders' : 'No past orders yet',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isActiveTab
                    ? 'Place a pre-order before your next class break!'
                    : 'Your completed canteen pre-orders will appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
              ),
              const SizedBox(height: 20),
              if (isActiveTab)
                ElevatedButton(
                  onPressed: () => context.go('/canteen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Explore Canteens'),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order, isActiveTab, canteenProvider, colors);
      },
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    CanteenOrder order,
    bool isActive,
    CanteenProvider provider,
    AppColorPalette colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? colors.primary.withValues(alpha: 0.35) : colors.borderSubtle,
          width: isActive ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Canteen name + Token Number Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.canteenName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.primaryText,
                      ),
                    ),
                    Text(
                      order.orderNumber,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    'TOKEN ${order.tokenNumber}',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Pickup Slot info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 14, color: colors.secondaryText),
                  const SizedBox(width: 6),
                  Text(
                    'Pickup: ${order.pickupSlot.label} (${order.pickupSlot.timeRange})',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Items Summary
            Text(
              order.items.map((i) => '${i.quantity}x ${i.foodItem.name}').join(', '),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colors.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Bottom Row: Status Chip + Price + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.inter(fontSize: 10.5, color: colors.mutedText),
                    ),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                  ],
                ),
                if (isActive)
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.setActiveTrackingOrder(order);
                      context.push('/canteen/order-tracking');
                    },
                    icon: const Icon(Icons.timeline_rounded, size: 16),
                    label: const Text('Track Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      provider.reorder(order);
                      context.push('/canteen/menu');
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 15),
                    label: const Text('Reorder'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
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
