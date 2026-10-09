import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';

class StudentHeader extends StatelessWidget {
  const StudentHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final notifications = context.watch<NotificationProvider>();
    final unreadCount = notifications.unreadCount;

    final userFullName = user?.profile?.fullName ?? '';
    final studentName = userFullName.isNotEmpty ? userFullName.split(' ').first : 'Student';
    final greeting = _getGreeting();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.border,
            width: 1.2,
          ),
          boxShadow: [
            colors.cardShadow,
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: ATTENT-IN Logo / Branding + Notification Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ATTENT-IN Logo & Wordmark
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      AppConstants.appLogo,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.school_rounded,
                        size: 28,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'ATTENT-IN',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),

              // Notification Bell
              Semantics(
                label: 'Notifications',
                button: true,
                child: InkWell(
                  onTap: () => context.push('/notifications'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.border,
                        width: 1,
                      ),
                      boxShadow: [
                        colors.cardShadow,
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 20,
                          color: colors.primary,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: 9,
                            right: 9,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.accentCyan,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.card,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Greeting & Subtitle
          Text(
            '$greeting, $studentName',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
              letterSpacing: -0.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Your intelligent student workspace.',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: colors.secondaryText,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    ),
  );
}
}
