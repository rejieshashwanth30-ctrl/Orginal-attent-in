import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final profile = user?.profile;

    final fullName = profile?.fullName ?? 'Aarav Sharma';
    final email = user?.email ?? 'student@demo.com';
    final college = profile?.college ?? 'National Institute of Technology';
    final department = profile?.department ?? 'Computer Science & Engineering';
    final year = profile?.year ?? 3;
    final rollNumber = profile?.rollNumber ?? '21BCSE088';
    final gpa = profile?.gpa ?? 8.7;
    final careerScore = profile?.careerScore ?? 72;

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final safeBottom = bottomInset > 0 ? bottomInset + 8.0 : 16.0;
    final contentBottomPadding = safeBottom + 68.0 + 20.0;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colors.primaryText,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.primaryText),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: contentBottomPadding),
              children: [
                // Top Profile Avatar & Name Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: colors.primary,
                        child: Text(
                          fullName.isNotEmpty ? fullName[0].toUpperCase() : 'S',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        fullName,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border, width: 0.8),
                        ),
                        child: Text(
                          '$department • Year $year',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Edit Profile Info',
                        type: AppButtonType.secondary,
                        icon: Icons.edit_outlined,
                        width: double.infinity,
                        onPressed: () => context.push('/profile-edit'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Performance Badges
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CGPA', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                            const SizedBox(height: 4),
                            Text('$gpa / 10.0', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: colors.primaryText)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Career Readiness', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                            const SizedBox(height: 4),
                            Text('$careerScore%', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: colors.primaryText)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Academic Enrollment Card
                const SectionHeader(title: 'Institutional Credentials', icon: Icons.badge_outlined),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileRow('Institution', college, Icons.school_outlined, colors),
                      Divider(height: 20, color: colors.border),
                      _buildProfileRow('Roll / Reg No.', rollNumber, Icons.numbers_outlined, colors),
                      Divider(height: 20, color: colors.border),
                      _buildProfileRow('Academic Status', 'Regular Full-Time', Icons.verified_outlined, colors),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // System Quick Nav
                const SectionHeader(title: 'ATTENT-IN Controls', icon: Icons.tune_rounded),
                _buildNavRow(context, 'System & App Settings (Themes & API)', Icons.settings_outlined, '/settings', colors),
                _buildNavRow(context, 'Explore All Feature Modules', Icons.apps_rounded, '/more', colors),

                const SizedBox(height: 24),

                // Logout Button
                AppButton(
                  text: 'Sign Out of ATTENT-IN',
                  type: AppButtonType.secondary,
                  icon: Icons.logout_rounded,
                  width: double.infinity,
                  onPressed: () async {
                    final confirmed = await AppDialog.show(
                      context,
                      title: 'Sign Out',
                      content: 'Are you sure you want to sign out of this device?',
                      confirmText: 'Sign Out',
                      isDestructive: true,
                    );
                    if (confirmed == true && context.mounted) {
                      await auth.logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon, AppColorPalette colors) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.mutedText),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
          ],
        ),
      ],
    );
  }

  Widget _buildNavRow(BuildContext context, String title, IconData icon, String route, AppColorPalette colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: () => context.push(route),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.primaryText),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryText,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: colors.mutedText),
          ],
        ),
      ),
    );
  }
}
