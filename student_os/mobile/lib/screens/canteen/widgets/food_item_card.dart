import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/canteen_models.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final int quantityInCart;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const FoodItemCard({
    super.key,
    required this.item,
    required this.quantityInCart,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quantityInCart > 0 ? colors.primary.withValues(alpha: 0.4) : colors.borderSubtle,
          width: quantityInCart > 0 ? 1.4 : 1.0,
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Details & Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Veg/Non-Veg icon + Best Seller chip
                  Row(
                    children: [
                      _buildVegBadge(item.isVeg),
                      if (item.isBestSeller) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department_rounded, size: 12, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 2),
                              Text(
                                'BESTSELLER',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFD97706),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Item Name
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryText,
                        ),
                      ),
                      if (item.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${item.originalPrice!.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.mutedText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    item.description,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: colors.secondaryText,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Calories & Prep Time
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 12, color: colors.mutedText),
                      const SizedBox(width: 3),
                      Text(
                        '${item.prepTimeMinutes}m prep',
                        style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.bolt_rounded, size: 12, color: colors.mutedText),
                      const SizedBox(width: 2),
                      Text(
                        '${item.calories} kcal',
                        style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Right Column: Emoji / Visual Avatar + Add to Cart Button
            Column(
              children: [
                // Food Image / Emoji Container
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.borderSubtle,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),

                const SizedBox(height: 10),

                // Add or Quantity Stepper
                if (quantityInCart == 0)
                  SizedBox(
                    width: 78,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: item.isAvailable ? onAdd : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ADD',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 78,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Minus Button
                        InkWell(
                          onTap: onDecrement,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                          child: const SizedBox(
                            width: 26,
                            height: 32,
                            child: Icon(Icons.remove, size: 14, color: Colors.white),
                          ),
                        ),
                        // Count
                        Text(
                          '$quantityInCart',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        // Plus Button
                        InkWell(
                          onTap: onIncrement,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                          child: const SizedBox(
                            width: 26,
                            height: 32,
                            child: Icon(Icons.add, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVegBadge(bool isVeg) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
