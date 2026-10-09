import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'ai_core_button.dart';

class AIFloatingDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAICoreTapped;
  final VoidCallback? onAICoreLongPress;

  const AIFloatingDock({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAICoreTapped,
    this.onAICoreLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final horizontalMargin = isWide ? 0.0 : 14.0;
        final dockMaxWidth = isWide ? 540.0 : double.infinity;

        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dockMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 0),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: 68,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.isDark ? const Color(0xEB181A1D) : const Color(0xEBEEF0F3),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: colors.border,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.isDark
                              ? Colors.black.withValues(alpha: 0.45)
                              : const Color(0xFF171A1F).withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: colors.primary.withValues(alpha: colors.isDark ? 0.16 : 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. HOME
                        _buildNavItem(
                          context: context,
                          index: 0,
                          icon: Icons.home_rounded,
                          selectedIcon: Icons.home_rounded,
                          label: 'Home',
                        ),

                        // 2. EXPLORE
                        _buildNavItem(
                          context: context,
                          index: 1,
                          icon: Icons.explore_outlined,
                          selectedIcon: Icons.explore_rounded,
                          label: 'Explore',
                        ),

                        // 3. CENTRAL AI CORE
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AICoreButton(
                            isSelected: currentIndex == 2,
                            onTap: onAICoreTapped,
                            onLongPress: onAICoreLongPress,
                          ),
                        ),

                        // 4. CHATS
                        _buildNavItem(
                          context: context,
                          index: 3,
                          icon: Icons.chat_bubble_outline_rounded,
                          selectedIcon: Icons.chat_bubble_rounded,
                          label: 'Chats',
                        ),

                        // 5. PROFILE
                        _buildNavItem(
                          context: context,
                          index: 4,
                          icon: Icons.person_outline_rounded,
                          selectedIcon: Icons.person_rounded,
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final colors = AppColors.of(context);
    final isSelected = currentIndex == index;
    final activeIcon = isSelected ? selectedIcon : icon;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabSelected(index),
          borderRadius: BorderRadius.circular(18),
          splashColor: colors.primary.withValues(alpha: 0.15),
          highlightColor: colors.primary.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: colors.isDark ? 0.16 : 0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: colors.primary.withValues(alpha: 0.35),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    activeIcon,
                    size: 20,
                    color: isSelected
                        ? (colors.isDark ? Colors.white : colors.primary)
                        : colors.mutedText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (colors.isDark ? Colors.white : colors.primary)
                        : colors.mutedText,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                // Glowing Active Underline / Dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 12 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.8),
                              blurRadius: 4,
                              spreadRadius: 0.5,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
