import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/canteen_provider.dart';
import 'widgets/canteen_card.dart';

class CanteenListScreen extends StatefulWidget {
  const CanteenListScreen({super.key});

  @override
  State<CanteenListScreen> createState() => _CanteenListScreenState();
}

class _CanteenListScreenState extends State<CanteenListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();
    final canteens = canteenProvider.canteens.where((c) {
      if (_filter.trim().isEmpty) return true;
      final q = _filter.toLowerCase().trim();
      return c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q) ||
          c.highlights.any((h) => h.toLowerCase().contains(q));
    }).toList();

    final activeOrders = canteenProvider.activeOrders;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/more');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Canteens',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              'Pre-order food & skip the break queue',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          // "My Orders" Button with Active Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.receipt_long_rounded, size: 22),
                tooltip: 'My Orders',
                onPressed: () => context.push('/canteen/orders'),
              ),
              if (activeOrders.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${activeOrders.length}',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // 1. Promotional Pre-Order Banner
            _buildPromoBanner(context, colors),

            const SizedBox(height: 16),

            // 2. Active Order Quick Access Card (if any active order)
            if (activeOrders.isNotEmpty) ...[
              _buildActiveOrderShortcut(context, activeOrders.first, canteenProvider, colors),
              const SizedBox(height: 16),
            ],

            // 3. Search Bar
            Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.borderSubtle, width: 1),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _filter = val),
                style: GoogleFonts.inter(fontSize: 13.5, color: colors.primaryText),
                decoration: InputDecoration(
                  hintText: 'Search canteens, dishes, burgers, thalis...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.mutedText),
                  prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.secondaryText),
                  suffixIcon: _filter.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _filter = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Section Title: SELECT CANTEEN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.storefront_rounded, size: 16, color: colors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'AVAILABLE CANTEENS (${canteens.length})',
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
                Text(
                  'Live counters',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: colors.secondaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 5. Canteen Cards List
            if (canteens.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: colors.mutedText),
                      const SizedBox(height: 12),
                      Text(
                        'No canteens match "$_filter"',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...canteens.map(
                (canteen) => CanteenCard(
                  canteen: canteen,
                  onTap: () {
                    canteenProvider.selectCanteen(canteen);
                    context.push('/canteen/menu');
                  },
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.12),
            colors.accentCyan.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('⚡', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-Order for Break & Lunch',
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Order before class ends. Walk in and grab your fresh meal at the express counter.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: colors.secondaryText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderShortcut(
    BuildContext context,
    CanteenOrder order,
    CanteenProvider provider,
    AppColorPalette colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.soup_kitchen_rounded, size: 20, color: Color(0xFFD97706)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ACTIVE PRE-ORDER',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFD97706),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '• Token ${order.tokenNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${order.canteenName} • ${order.status.displayName}',
                  style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setActiveTrackingOrder(order);
              context.push('/canteen/order-tracking');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Track',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
