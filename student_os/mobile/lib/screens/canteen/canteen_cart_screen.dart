import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/canteen_provider.dart';
import '../../../services/mock_data_service.dart';
import 'widgets/pickup_time_selector.dart';

class CanteenCartScreen extends StatefulWidget {
  const CanteenCartScreen({super.key});

  @override
  State<CanteenCartScreen> createState() => _CanteenCartScreenState();
}

class _CanteenCartScreenState extends State<CanteenCartScreen> {
  final TextEditingController _notesCtrl = TextEditingController();
  String _selectedPayment = 'Campus Student Pay';

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final canteenProvider = context.watch<CanteenProvider>();
    final authProvider = context.watch<AuthProvider>();

    final user = authProvider.user ?? MockDataService.currentUser;
    final profile = user.profile;

    final cartItems = canteenProvider.cart;
    final canteen = canteenProvider.selectedCanteen;

    if (cartItems.isEmpty || canteen == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => context.pop(),
          ),
          title: const Text('Pre-Order Cart'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_shopping_cart_outlined, size: 56, color: colors.mutedText),
              const SizedBox(height: 14),
              Text(
                'Your cart is empty',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add dishes from the canteen menu to pre-order',
                style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Browse Canteen Menu'),
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
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pre-Order Checkout',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              '${canteen.name} • ${canteen.code}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              canteenProvider.clearCart();
            },
            icon: Icon(Icons.delete_outline_rounded, size: 16, color: colors.danger),
            label: Text(
              'Clear',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.danger,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // 1. Canteen Summary Header Card
            _buildCanteenSummaryCard(canteen, colors),

            const SizedBox(height: 18),

            // 2. Pre-Order Timing Selector (Upcoming Break / Lunch / Custom)
            PickupTimeSelector(
              selectedSlot: canteenProvider.selectedPickupSlot,
              customTime: canteenProvider.customPickupTime,
              onSelectSlot: (slot) => canteenProvider.setPickupSlot(slot),
              onSelectCustomTime: (time) => canteenProvider.setCustomPickupTime(time),
            ),

            const SizedBox(height: 20),

            // 3. Selected Items List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 16, color: colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'ORDER ITEMS (${cartItems.length})',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: colors.primaryText,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => context.pop(),
                  child: Text(
                    '+ Add more items',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...cartItems.map(
              (cartItem) => _buildCartItemCard(cartItem, canteenProvider, colors),
            ),

            const SizedBox(height: 18),

            // 4. Cooking Instructions / Special Requests
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderSubtle, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note_rounded, size: 16, color: colors.secondaryText),
                      const SizedBox(width: 6),
                      Text(
                        'Kitchen Note / Special Instructions',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesCtrl,
                    onChanged: (val) => canteenProvider.setSpecialInstructions(val),
                    style: GoogleFonts.inter(fontSize: 12.5, color: colors.primaryText),
                    decoration: InputDecoration(
                      hintText: 'e.g. Less spicy, extra coconut chutney, pack separately',
                      hintStyle: GoogleFonts.inter(fontSize: 12, color: colors.mutedText),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 5. Student Details Card
            _buildStudentDetailsCard(profile, colors),

            const SizedBox(height: 18),

            // 6. Payment Method Selector
            _buildPaymentMethodSection(colors),

            const SizedBox(height: 18),

            // 7. Bill Details Breakdown Card
            _buildBillDetailsCard(canteenProvider, colors),

            const SizedBox(height: 24),

            // 8. Place Order Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: canteenProvider.isPlacingOrder
                    ? null
                    : () async {
                        final studentName = profile?.fullName ?? 'Aarav Sharma';
                        final rollNum = profile?.rollNumber ?? '21BCSE088';
                        final phone = profile?.phone ?? '+91 98765 43210';

                        final newOrder = await canteenProvider.placeOrder(
                          studentName: studentName,
                          studentRollNumber: rollNum,
                          studentPhone: phone,
                          paymentMethod: _selectedPayment,
                        );

                        if (newOrder != null && context.mounted) {
                          context.go('/canteen/order-success');
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: canteenProvider.isPlacingOrder
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Place Pre-Order • ₹${canteenProvider.cartGrandTotal.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteenSummaryCard(Canteen canteen, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: canteen.themeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(canteen.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  canteen.name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  canteen.counterInfo,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(
    CartItem item,
    CanteenProvider provider,
    AppColorPalette colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          // Emoji
          Text(item.foodItem.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),

          // Name & Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodItem.name,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${item.foodItem.price.toStringAsFixed(0)} each',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: colors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Stepper
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 28),
                  icon: const Icon(Icons.remove, size: 14),
                  onPressed: () => provider.removeFromCart(item.foodItem),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 28),
                  icon: const Icon(Icons.add, size: 14),
                  onPressed: () => provider.addToCart(item.foodItem),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Total Price
          Text(
            '₹${item.totalPrice.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDetailsCard(dynamic profile, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_outlined, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'STUDENT PICKUP PROFILE',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.fullName ?? 'Aarav Sharma',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Roll: ${profile?.rollNumber ?? "21BCSE088"} • ${profile?.department ?? "CSE"}',
                    style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'VERIFIED ID',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: colors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(AppColorPalette colors) {
    final methods = [
      {'title': 'Campus Student Pay', 'desc': 'Instant balance deduction', 'icon': Icons.account_balance_wallet_rounded},
      {'title': 'UPI / GPay / PhonePe', 'desc': 'Fast simulated scan', 'icon': Icons.qr_code_scanner_rounded},
      {'title': 'Pay at Express Counter', 'desc': 'Cash / Card on collection', 'icon': Icons.point_of_sale_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'PAYMENT METHOD',
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
          ...methods.map((m) {
            final isSelected = _selectedPayment == m['title'];
            return InkWell(
              onTap: () => setState(() => _selectedPayment = m['title'] as String),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      m['icon'] as IconData,
                      size: 20,
                      color: isSelected ? colors.primary : colors.secondaryText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? colors.primary : colors.primaryText,
                            ),
                          ),
                          Text(
                            m['desc'] as String,
                            style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: m['title'] as String,
                      groupValue: _selectedPayment,
                      activeColor: colors.primary,
                      onChanged: (v) => setState(() => _selectedPayment = v!),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard(CanteenProvider provider, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'BILL BREAKDOWN',
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
          _buildBillRow('Items Subtotal', '₹${provider.cartSubtotal.toStringAsFixed(2)}', colors),
          const SizedBox(height: 6),
          _buildBillRow('GST & Kitchen Tax (5%)', '₹${provider.cartTax.toStringAsFixed(2)}', colors),
          if (provider.cartDiscount > 0) ...[
            const SizedBox(height: 6),
            _buildBillRow('Campus Student Subsidy Discount', '-₹${provider.cartDiscount.toStringAsFixed(2)}', colors, isDiscount: true),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              Text(
                '₹${provider.cartGrandTotal.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, AppColorPalette colors, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: isDiscount ? colors.success : colors.secondaryText,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDiscount ? colors.success : colors.primaryText,
          ),
        ),
      ],
    );
  }
}
