import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide? border;
  final double borderRadius;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius = 18,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bg = backgroundColor ?? colors.card;
    final b = border ?? BorderSide(color: colors.border, width: 1);

    Widget content = Padding(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: colors.primary.withValues(alpha: 0.1),
        highlightColor: colors.primary.withValues(alpha: 0.05),
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          colors.cardShadow,
        ],
      ),
      child: Material(
        color: gradient == null ? bg : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: b,
        ),
        clipBehavior: Clip.antiAlias,
        child: gradient != null
            ? Ink(
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}
