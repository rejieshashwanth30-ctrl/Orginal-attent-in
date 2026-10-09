import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hostel_models.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class HostelMessScreen extends StatefulWidget {
  const HostelMessScreen({super.key});

  @override
  State<HostelMessScreen> createState() => _HostelMessScreenState();
}

class _HostelMessScreenState extends State<HostelMessScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    // Default to today's weekday
    final currentDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
    _selectedDayIndex = (currentDay - 1).clamp(0, 6);
  }

  void _openEditMenuSheet(BuildContext context, MessMenu menu) {
    final breakfastController = TextEditingController(text: menu.breakfast);
    final lunchController = TextEditingController(text: menu.lunch);
    final dinnerController = TextEditingController(text: menu.dinner);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final modalColors = AppColors.of(ctx);
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: modalColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit ${menu.dayOfWeek} Menu',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: modalColors.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: modalColors.secondaryText),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: breakfastController,
                  label: 'Breakfast Items',
                  hint: 'e.g. Idli + Sambar + Coffee',
                  prefixIcon: Icons.free_breakfast_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: lunchController,
                  label: 'Lunch Items',
                  hint: 'e.g. Rice + Dal + Veg Curry',
                  prefixIcon: Icons.lunch_dining_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: dinnerController,
                  label: 'Dinner Items',
                  hint: 'e.g. Chapati + Paneer + Rice',
                  prefixIcon: Icons.dinner_dining_outlined,
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Save Menu Changes',
                  width: double.infinity,
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () {
                    context.read<HostelProvider>().updateMessMenuForDay(
                          menu.dayOfWeek,
                          breakfast: breakfastController.text.trim(),
                          lunch: lunchController.text.trim(),
                          dinner: dinnerController.text.trim(),
                        );
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${menu.dayOfWeek} mess menu updated successfully!')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hostelProvider = context.watch<HostelProvider>();
    final menus = hostelProvider.weeklyMessMenu;
    final currentMenu = menus.length > _selectedDayIndex ? menus[_selectedDayIndex] : menus.first;

    final todayWeekdayIndex = (DateTime.now().weekday - 1).clamp(0, 6);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Mess & Dining Schedule',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, size: 24, color: colors.primary),
            tooltip: 'Edit Today\'s Menu',
            onPressed: () => _openEditMenuSheet(context, currentMenu),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Day selector strip
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final isSelected = index == _selectedDayIndex;
                  final isToday = index == todayWeekdayIndex;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedDayIndex = index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : colors.elevatedCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : (isToday ? colors.primary : Colors.transparent),
                            width: isToday ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              day.substring(0, 3),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : colors.primaryText,
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Scrollable Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Special Feast Banner if applicable
                  if (currentMenu.isSpecialDay)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Special Menu Day',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  currentMenu.specialNote ?? 'Grand Special Feast Included!',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 1. Breakfast Card
                  _buildMealCard(
                    context: context,
                    mealName: 'Breakfast',
                    timeRange: '7:30 AM – 9:00 AM',
                    items: currentMenu.breakfast,
                    icon: Icons.free_breakfast_rounded,
                    accentColor: colors.warning,
                    colors: colors,
                  ),

                  const SizedBox(height: 14),

                  // 2. Lunch Card
                  _buildMealCard(
                    context: context,
                    mealName: 'Lunch',
                    timeRange: '12:30 PM – 2:00 PM',
                    items: currentMenu.lunch,
                    icon: Icons.lunch_dining_rounded,
                    accentColor: colors.success,
                    colors: colors,
                  ),

                  const SizedBox(height: 14),

                  // 3. Evening Snacks Card
                  _buildMealCard(
                    context: context,
                    mealName: 'Evening Tea & Snacks',
                    timeRange: '4:30 PM – 5:30 PM',
                    items: currentMenu.snacks,
                    icon: Icons.bakery_dining_rounded,
                    accentColor: colors.secondary,
                    colors: colors,
                  ),

                  const SizedBox(height: 14),

                  // 4. Dinner Card
                  _buildMealCard(
                    context: context,
                    mealName: 'Dinner',
                    timeRange: '7:30 PM – 9:30 PM',
                    items: currentMenu.dinner,
                    icon: Icons.dinner_dining_rounded,
                    accentColor: colors.primary,
                    colors: colors,
                  ),

                  const SizedBox(height: 20),

                  // Mess Timings & Rules Information
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 18, color: colors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Mess Guidelines',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildGuidelineRow('Mess ID Card is mandatory for entry at food counters.', colors),
                        _buildGuidelineRow('Food wastage is strictly monitored by the Mess Committee.', colors),
                        _buildGuidelineRow('Late dinner tokens can be requested via Chief Warden before 6 PM.', colors),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required BuildContext context,
    required String mealName,
    required String timeRange,
    required String items,
    required IconData icon,
    required Color accentColor,
    required AppColorPalette colors,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                    Text(
                      timeRange,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.elevatedCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.border,
              ),
            ),
            child: Text(
              items,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: colors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineRow(String text, AppColorPalette colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 8),
            child: Icon(Icons.circle, size: 5, color: colors.primary),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
