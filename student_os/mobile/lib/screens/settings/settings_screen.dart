import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _serverUrlController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _attendanceAlerts = true;

  @override
  void initState() {
    super.initState();
    _serverUrlController.text = ApiConstants.baseUrl;
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveServerUrl() async {
    final newUrl = _serverUrlController.text.trim();
    if (newUrl.isNotEmpty) {
      await ApiConstants.setCustomBaseUrl(newUrl);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backend API host updated to: $newUrl')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'System Settings',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colors.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Theme Mode
            const SectionHeader(title: 'Visual Theme & Appearance', icon: Icons.palette_outlined),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildThemeOption(
                    title: 'System Default',
                    subtitle: 'Match system device or browser appearance automatically',
                    icon: Icons.brightness_auto_rounded,
                    mode: ThemeMode.system,
                    currentMode: themeProvider.themeMode,
                    onSelect: () => themeProvider.setThemeMode(ThemeMode.system),
                    colors: colors,
                  ),
                  Divider(height: 16, color: colors.border),
                  _buildThemeOption(
                    title: 'Minimalist Light Mode',
                    subtitle: 'Clean off-white & light gray with soft blue accents',
                    icon: Icons.light_mode_rounded,
                    mode: ThemeMode.light,
                    currentMode: themeProvider.themeMode,
                    onSelect: () => themeProvider.setThemeMode(ThemeMode.light),
                    colors: colors,
                  ),
                  Divider(height: 16, color: colors.border),
                  _buildThemeOption(
                    title: 'Deep Monochromatic Dark Mode',
                    subtitle: 'Rich deep charcoal & dark blue tones for night focus',
                    icon: Icons.dark_mode_rounded,
                    mode: ThemeMode.dark,
                    currentMode: themeProvider.themeMode,
                    onSelect: () => themeProvider.setThemeMode(ThemeMode.dark),
                    colors: colors,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Server & Network Connectivity
            const SectionHeader(title: 'Backend API Server Configuration', icon: Icons.dns_outlined),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customize Node.js / Express API endpoint (Useful when testing on physical devices over LAN vs Emulator):',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _serverUrlController,
                    label: 'API Base URL',
                    hint: 'http://10.0.2.2:5000/api',
                    prefixIcon: Icons.link_rounded,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _serverUrlController.text = 'http://10.0.2.2:5000/api';
                            _saveServerUrl();
                          },
                          child: const Text('Emulator (10.0.2.2)', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _serverUrlController.text = 'http://localhost:5000/api';
                            _saveServerUrl();
                          },
                          child: const Text('Local (localhost)', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Save & Reconnect API',
                    width: double.infinity,
                    onPressed: _saveServerUrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Notification Toggles
            const SectionHeader(title: 'Notification Preferences', icon: Icons.notifications_active_outlined),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notificationsEnabled,
                    activeThumbColor: colors.primary,
                    title: Text('Push Notifications', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                    subtitle: Text('Assignment reminders & schedule alerts', style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  Divider(height: 8, color: colors.border),
                  SwitchListTile(
                    value: _attendanceAlerts,
                    activeThumbColor: colors.danger,
                    title: Text('Low Attendance Alerts', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                    subtitle: Text('Trigger immediate warnings if below 75%', style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                    onChanged: (val) => setState(() => _attendanceAlerts = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About ATTENT-IN
            const SectionHeader(title: 'About ATTENT-IN', icon: Icons.info_outline),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Image.asset(
                        AppConstants.appLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(Icons.school_rounded, size: 36, color: colors.primary),
                      ),
                    ),
                  ),
                  _buildAboutRow('Application', AppConstants.appName, colors),
                  Divider(height: 16, color: colors.border),
                  _buildAboutRow('Tagline', AppConstants.appTagline, colors),
                  Divider(height: 16, color: colors.border),
                  _buildAboutRow('Version', 'v${AppConstants.appVersion}', colors),
                  Divider(height: 16, color: colors.border),
                  _buildAboutRow('Package ID', AppConstants.packageName, colors),
                  Divider(height: 16, color: colors.border),
                  _buildAboutRow('Framework', 'Pure Flutter 3 & Dart', colors),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutRow(String label, String value, AppColorPalette colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onSelect,
    required AppColorPalette colors,
  }) {
    final isSelected = mode == currentMode;
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? colors.subtleAccentBg : colors.elevatedCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? colors.primary : colors.mutedText,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.mutedText,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
