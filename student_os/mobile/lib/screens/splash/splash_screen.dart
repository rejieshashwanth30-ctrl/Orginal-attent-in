import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final size = MediaQuery.of(context).size;
    final double logoSize = (size.width * 0.50).clamp(160.0, 240.0);

    return Scaffold(
      backgroundColor: colors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: colors.background,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Full Official ATTENT-IN Transparent Logo
              Center(
                child: SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: Image.asset(
                    AppConstants.appLogo,
                    fit: BoxFit.contain,
                    semanticLabel: 'ATTENT-IN Logo',
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 700.ms, curve: Curves.easeOutCubic)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 20),

              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.secondaryText,
                  letterSpacing: 0.2,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

              const Spacer(flex: 3),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'v${AppConstants.appVersion} • ATTENT-IN',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.mutedText,
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
