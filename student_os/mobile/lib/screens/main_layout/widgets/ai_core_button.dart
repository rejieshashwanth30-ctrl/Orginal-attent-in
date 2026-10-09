import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AICoreButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const AICoreButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<AICoreButton> createState() => _AICoreButtonState();
}

class _AICoreButtonState extends State<AICoreButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScaleAnimation;
  late Animation<double> _pulseGlowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _pulseScaleAnimation = Tween<double>(begin: 0.98, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _pulseGlowAnimation = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final idleScale = _pulseScaleAnimation.value;
        final idleGlow = _pulseGlowAnimation.value;
        final effectiveScale = _isPressed ? 0.92 : (widget.isSelected ? 1.08 : idleScale);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          onLongPress: widget.onLongPress,
          behavior: HitTestBehavior.opaque,
          child: Transform.scale(
            scale: effectiveScale,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  // Outer Living Ambient Glow
                  BoxShadow(
                    color: (widget.isSelected
                            ? colors.accentCyan
                            : colors.primary)
                        .withValues(alpha: widget.isSelected ? 0.7 : (colors.isDark ? idleGlow : idleGlow * 0.5)),
                    blurRadius: widget.isSelected ? 18 : 14,
                    spreadRadius: widget.isSelected ? 2 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Outer Ring
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: widget.isSelected
                            ? colors.primary
                            : colors.border,
                        width: 1.5,
                      ),
                    ),
                  ),

                  // 2. Electric Blue to Cyan Gradient Ring
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: widget.isSelected
                            ? [colors.accentCyan, colors.primaryLight]
                            : [colors.primary, colors.accentCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.35),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),

                  // 3. Inner Core Surface
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: colors.isDark
                            ? const [
                                Color(0xFF24272C),
                                Color(0xFF181A1D),
                              ]
                            : const [
                                Color(0xFFEAF2FF),
                                Color(0xFFEEF0F3),
                              ],
                        center: const Alignment(0.0, -0.2),
                        radius: 0.9,
                      ),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Subtle inner sparkle effect
                          Transform.rotate(
                            angle: _pulseController.value * math.pi,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    Colors.transparent,
                                    colors.primary.withValues(alpha: 0.25),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Glowing AI / Robot Icon
                          Icon(
                            Icons.smart_toy_rounded,
                            color: colors.isDark ? Colors.white : colors.primary,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
