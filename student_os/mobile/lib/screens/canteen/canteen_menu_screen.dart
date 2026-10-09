import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/canteen_provider.dart';
import 'widgets/food_item_card.dart';

class CanteenMenuScreen extends StatefulWidget {
  const CanteenMenuScreen({super.key});

  @override
  State<CanteenMenuScreen> createState() => _CanteenMenuScreenState();
}

class _CanteenMenuScreenState extends State<CanteenMenuScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();
    final canteen = canteenProvider.selectedCanteen;

    if (canteen == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('Menu')),
        body: Center(
          child: Text(
            'No canteen selected',
            style: GoogleFonts.outfit(color: colors.primaryText),
          ),
        ),
      );
    }

    final menuItems = canteenProvider.filteredMenu;
    final cartCount = canteenProvider.cartCount;
    final cartSubtotal = canteenProvider.cartSubtotal;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              canteen.name,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              canteen.location.split('(').first.trim(),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          // Cart Button in App Bar
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 22),
                tooltip: 'Cart',
                onPressed: () {
                  if (cartCount > 0) {
                    context.push('/canteen/cart');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your cart is empty. Add some tasty items first!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              if (cartCount > 0)
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
                      '$cartCount',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
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
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Canteen Info Strip
                _buildCanteenHeaderStrip(canteen, colors),

                // 2. Search & Veg Toggle Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                  child: Row(
                    children: [
                      // Search field
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.borderSubtle, width: 1),
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => canteenProvider.setSearchQuery(v),
                            style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                            decoration: InputDecoration(
                              hintText: 'Search items in ${canteen.code}...',
                              hintStyle: GoogleFonts.inter(fontSize: 12.5, color: colors.mutedText),
                              prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.secondaryText),
                              suffixIcon: _searchCtrl.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 16),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        canteenProvider.clearSearch();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Pure Veg Toggle Chip
                      FilterChip(
                        selected: canteenProvider.onlyVeg,
                        onSelected: (_) => canteenProvider.toggleVegOnly(),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF16A34A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Veg',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: canteenProvider.onlyVeg ? Colors.white : colors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        selectedColor: const Color(0xFF16A34A),
                        backgroundColor: colors.card,
                        checkmarkColor: Colors.white,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: canteenProvider.onlyVeg ? const Color(0xFF16A34A) : colors.borderSubtle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Category Horizontal Tabs
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: canteen.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = canteen.categories[index];
                      final isSelected = canteenProvider.selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(
                          cat,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : colors.primaryText,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => canteenProvider.selectCategory(cat),
                        selectedColor: colors.primary,
                        backgroundColor: colors.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? colors.primary : colors.borderSubtle,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 4. Menu Items List
                Expanded(
                  child: menuItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 48, color: colors.mutedText),
                              const SizedBox(height: 12),
                              Text(
                                'No dishes found',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try clearing filters or search another category',
                                style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 6,
                            bottom: cartCount > 0 ? 90 : 20,
                          ),
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) {
                            final item = menuItems[index];
                            final qty = canteenProvider.getItemQuantityInCart(item.id);
                            return FoodItemCard(
                              item: item,
                              quantityInCart: qty,
                              onAdd: () => canteenProvider.addToCart(item),
                              onIncrement: () => canteenProvider.addToCart(item),
                              onDecrement: () => canteenProvider.removeFromCart(item),
                            );
                          },
                        ),
                ),
              ],
            ),

            // 5. Sticky Bottom Cart Bar
            if (cartCount > 0)
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Cart Item Count & Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$cartCount ${cartCount == 1 ? "ITEM" : "ITEMS"} SELECTED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withValues(alpha: 0.85),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${cartSubtotal.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // View Cart & Pre-Order Button
                      InkWell(
                        onTap: () => context.push('/canteen/cart'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Cart & Pre-Order',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteenHeaderStrip(Canteen canteen, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  canteen.emoji,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${canteen.operatingHours} • ~${canteen.averagePrepMinutes}m prep',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: colors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                const SizedBox(width: 2),
                Text(
                  canteen.rating.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
