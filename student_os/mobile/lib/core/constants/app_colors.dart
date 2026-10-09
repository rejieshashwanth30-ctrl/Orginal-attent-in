import 'package:flutter/material.dart';

/// Complete Color Palette Definition for ATTENT-IN
class AppColorPalette {
  final bool isDark;
  final Color background;
  final Color secondaryBackground;
  final Color surface;
  final Color surfaceSecondary;
  final Color card;
  final Color elevatedCard;
  final Color cardHighlight;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final Color disabledText;
  final Color border;
  final Color borderSubtle;
  final Color borderLight;
  final Color divider;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color accent;
  final Color accentCyan;
  final Color subtleAccentBg;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color navBackground;
  final Color navBorder;
  final Color navSelected;
  final Color navUnselected;
  final BoxShadow cardShadow;
  final LinearGradient primaryGradient;
  final LinearGradient subtleCardGradient;
  final LinearGradient accentGradient;

  final Color categoryAcademic;
  final Color categoryCareer;
  final Color categoryProject;
  final Color categoryPersonal;
  final Color categoryOther;

  const AppColorPalette({
    required this.isDark,
    required this.background,
    required this.secondaryBackground,
    required this.surface,
    required this.surfaceSecondary,
    required this.card,
    required this.elevatedCard,
    required this.cardHighlight,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.disabledText,
    required this.border,
    required this.borderSubtle,
    required this.borderLight,
    required this.divider,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.accent,
    required this.accentCyan,
    required this.subtleAccentBg,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.navBackground,
    required this.navBorder,
    required this.navSelected,
    required this.navUnselected,
    required this.cardShadow,
    required this.primaryGradient,
    required this.subtleCardGradient,
    required this.accentGradient,
    this.categoryAcademic = const Color(0xFF2563EB),
    this.categoryCareer = const Color(0xFF10B981),
    this.categoryProject = const Color(0xFF8B5CF6),
    this.categoryPersonal = const Color(0xFFF59E0B),
    this.categoryOther = const Color(0xFF6B7280),
  });

  /// 1. MINIMALIST OFF-WHITE & LIGHT GRAY — LIGHT MODE
  static const light = AppColorPalette(
    isDark: false,
    background: Color(0xFFF5F6F8),          // Off-white background
    secondaryBackground: Color(0xFFEEF0F3), // Light gray secondary
    surface: Color(0xFFEEF0F3),
    surfaceSecondary: Color(0xFFFAFAFB),
    card: Color(0xFFFFFFFF),                // Pure white cards
    elevatedCard: Color(0xFFFAFAFB),        // Soft elevated card
    cardHighlight: Color(0xFFEAF2FF),
    primaryText: Color(0xFF171A1F),         // High-contrast dark slate
    secondaryText: Color(0xFF626B78),       // Medium gray
    mutedText: Color(0xFF8A929E),           // Muted light gray
    disabledText: Color(0xFFB0B7C3),
    border: Color(0xFFE1E4E8),              // Crisp light border
    borderSubtle: Color(0xFFECEFF2),
    borderLight: Color(0xFF3B82F6),
    divider: Color(0xFFE5E8EC),
    primary: Color(0xFF2563EB),             // Primary Accent Blue
    primaryDark: Color(0xFF1D4ED8),
    primaryLight: Color(0xFF3B82F6),        // Secondary Accent Blue
    secondary: Color(0xFF3B82F6),
    accent: Color(0xFF2563EB),
    accentCyan: Color(0xFF0284C7),
    subtleAccentBg: Color(0xFFEAF2FF),      // Soft Blue Background Tint
    success: Color(0xFF16A34A),             // Success Green
    warning: Color(0xFFD97706),             // Warning Amber
    danger: Color(0xFFDC2626),              // Error Red
    info: Color(0xFF0284C7),
    navBackground: Color(0xF0EEF0F3),
    navBorder: Color(0xFFE1E4E8),
    navSelected: Color(0xFF2563EB),
    navUnselected: Color(0xFF8A929E),
    cardShadow: BoxShadow(
      color: Color(0x0A171A1F),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    subtleCardGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF0284C7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    categoryAcademic: Color(0xFF2563EB),
    categoryCareer: Color(0xFF059669),
    categoryProject: Color(0xFF7C3AED),
    categoryPersonal: Color(0xFFD97706),
    categoryOther: Color(0xFF4B5563),
  );

  /// 2. DEEP MONOCHROMATIC DARK MODE — DARK MODE
  static const dark = AppColorPalette(
    isDark: true,
    background: Color(0xFF121212),          // Deep charcoal background
    secondaryBackground: Color(0xFF181A1D), // Dark charcoal secondary
    surface: Color(0xFF181A1D),
    surfaceSecondary: Color(0xFF24272C),
    card: Color(0xFF1E2024),                // Deep charcoal card
    elevatedCard: Color(0xFF24272C),        // Elevated dark card
    cardHighlight: Color(0xFF2B2F36),
    primaryText: Color(0xFFF5F5F5),         // Off-white primary text
    secondaryText: Color(0xFFB5BAC4),       // Light gray secondary text
    mutedText: Color(0xFF7F8793),           // Muted medium-dark text
    disabledText: Color(0xFF4B515D),
    border: Color(0xFF2D3138),              // Dark border
    borderSubtle: Color(0xFF22252A),
    borderLight: Color(0xFF5B8CFF),
    divider: Color(0xFF262930),
    primary: Color(0xFF5B8CFF),             // Primary Refined Blue
    primaryDark: Color(0xFF3B6FE0),
    primaryLight: Color(0xFF6FA3FF),        // Secondary Accent Blue
    secondary: Color(0xFF6FA3FF),
    accent: Color(0xFF5B8CFF),
    accentCyan: Color(0xFF38BDF8),
    subtleAccentBg: Color(0xFF202B42),      // Subtle Dark Blue Tint
    success: Color(0xFF4ADE80),             // Success
    warning: Color(0xFFFBBF24),             // Warning
    danger: Color(0xFFF87171),              // Error
    info: Color(0xFF38BDF8),
    navBackground: Color(0xEB181A1D),
    navBorder: Color(0xFF2D3138),
    navSelected: Color(0xFF5B8CFF),
    navUnselected: Color(0xFF7F8793),
    cardShadow: BoxShadow(
      color: Color(0x38000000),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF5B8CFF), Color(0xFF3B6FE0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    subtleCardGradient: LinearGradient(
      colors: [Color(0xFF1E2024), Color(0xFF181A1D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF5B8CFF), Color(0xFF38BDF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    categoryAcademic: Color(0xFF5B8CFF),
    categoryCareer: Color(0xFF10B981),
    categoryProject: Color(0xFF8B5CF6),
    categoryPersonal: Color(0xFFF59E0B),
    categoryOther: Color(0xFF6B7280),
  );
}

/// Centralized Design System Colors for ATTENT-IN
/// Supports both:
/// 1. MINIMALIST OFF-WHITE & LIGHT GRAY — LIGHT MODE
/// 2. DEEP MONOCHROMATIC DARK MODE — DARK MODE
class AppColors {
  // Light Palette Tokens
  static const Color lightBackground = Color(0xFFF5F6F8);
  static const Color lightBg = Color(0xFFF5F6F8);
  static const Color lightSecondaryBackground = Color(0xFFEEF0F3);
  static const Color lightSurface = Color(0xFFEEF0F3);
  static const Color lightSurfaceSecondary = Color(0xFFFAFAFB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightElevatedCard = Color(0xFFFAFAFB);
  static const Color lightCardHighlight = Color(0xFFEAF2FF);
  static const Color lightPrimaryText = Color(0xFF171A1F);
  static const Color lightTextPrimary = Color(0xFF171A1F);
  static const Color lightSecondaryText = Color(0xFF626B78);
  static const Color lightTextSecondary = Color(0xFF626B78);
  static const Color lightMutedText = Color(0xFF8A929E);
  static const Color lightTextMuted = Color(0xFF8A929E);
  static const Color lightDisabledText = Color(0xFFB0B7C3);
  static const Color lightBorder = Color(0xFFE1E4E8);
  static const Color lightBorderSubtle = Color(0xFFECEFF2);
  static const Color lightBorderLight = Color(0xFF3B82F6);
  static const Color lightDivider = Color(0xFFE5E8EC);
  static const Color lightPrimary = Color(0xFF2563EB);
  static const Color lightPrimaryDark = Color(0xFF1D4ED8);
  static const Color lightPrimaryLight = Color(0xFF3B82F6);
  static const Color lightSecondary = Color(0xFF3B82F6);
  static const Color lightAccent = Color(0xFF2563EB);
  static const Color lightAccentCyan = Color(0xFF0284C7);
  static const Color lightSubtleAccentBg = Color(0xFFEAF2FF);
  static const Color lightSuccess = Color(0xFF16A34A);
  static const Color lightWarning = Color(0xFFD97706);
  static const Color lightDanger = Color(0xFFDC2626);
  static const Color lightInfo = Color(0xFF0284C7);
  static const Color lightNavBackground = Color(0xF0EEF0F3);
  static const Color lightNavBorder = Color(0xFFE1E4E8);
  static const Color lightNavSelected = Color(0xFF2563EB);
  static const Color lightNavUnselected = Color(0xFF8A929E);

  // Dark Palette Tokens (Deep Monochromatic)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSecondaryBackground = Color(0xFF181A1D);
  static const Color darkSurface = Color(0xFF181A1D);
  static const Color darkSurfaceSecondary = Color(0xFF24272C);
  static const Color darkCard = Color(0xFF1E2024);
  static const Color darkElevatedCard = Color(0xFF24272C);
  static const Color darkCardHighlight = Color(0xFF2B2F36);
  static const Color darkPrimaryText = Color(0xFFF5F5F5);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkSecondaryText = Color(0xFFB5BAC4);
  static const Color darkTextSecondary = Color(0xFFB5BAC4);
  static const Color darkMutedText = Color(0xFF7F8793);
  static const Color darkTextMuted = Color(0xFF7F8793);
  static const Color darkDisabledText = Color(0xFF4B515D);
  static const Color darkBorder = Color(0xFF2D3138);
  static const Color darkBorderSubtle = Color(0xFF22252A);
  static const Color darkBorderLight = Color(0xFF5B8CFF);
  static const Color darkDivider = Color(0xFF262930);
  static const Color darkPrimary = Color(0xFF5B8CFF);
  static const Color darkPrimaryDark = Color(0xFF3B6FE0);
  static const Color darkPrimaryLight = Color(0xFF6FA3FF);
  static const Color darkSecondary = Color(0xFF6FA3FF);
  static const Color darkAccent = Color(0xFF5B8CFF);
  static const Color darkAccentCyan = Color(0xFF38BDF8);
  static const Color darkSubtleAccentBg = Color(0xFF202B42);
  static const Color darkSuccess = Color(0xFF4ADE80);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkDanger = Color(0xFFF87171);
  static const Color darkInfo = Color(0xFF38BDF8);
  static const Color darkNavBackground = Color(0xEB181A1D);
  static const Color darkNavBorder = Color(0xFF2D3138);
  static const Color darkNavSelected = Color(0xFF5B8CFF);
  static const Color darkNavUnselected = Color(0xFF7F8793);

  // Static Fallbacks / Defaults for Non-Context Lookups
  static const Color background = darkBackground;
  static const Color secondaryBackground = darkSecondaryBackground;
  static const Color surface = darkSecondaryBackground;
  static const Color surfaceSecondary = darkElevatedCard;
  static const Color card = darkCard;
  static const Color elevatedCard = darkElevatedCard;
  static const Color cardHighlight = Color(0xFF2B2F36);

  static const Color border = darkBorder;
  static const Color borderSubtle = Color(0xFF22252A);
  static const Color borderLight = darkPrimary;
  static const Color borderWhite = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFF262930);

  static const Color primaryText = darkPrimaryText;
  static const Color textPrimary = darkPrimaryText;
  static const Color secondaryText = darkSecondaryText;
  static const Color textSecondary = darkSecondaryText;
  static const Color mutedText = darkMutedText;
  static const Color textMuted = darkMutedText;
  static const Color disabledText = Color(0xFF4B515D);

  static const Color primary = darkPrimary;
  static const Color primaryDark = Color(0xFF3B6FE0);
  static const Color primaryLight = darkPrimaryLight;
  static const Color accent = darkAccent;
  static const Color accentCyan = darkAccentCyan;
  static const Color cyan = darkAccentCyan;
  static const Color secondary = darkSecondary;
  static const Color accentMuted = Color(0xFF93C5FD);
  static const Color accentDark = Color(0xFF202B42);
  static const Color subtleAccentBg = darkSubtleAccentBg;

  static const Color navBackground = Color(0xEB181A1D);
  static const Color navBorder = darkBorder;
  static const Color navSelected = darkPrimary;
  static const Color navUnselected = darkMutedText;

  static const Color success = darkSuccess;
  static const Color warning = darkWarning;
  static const Color danger = darkDanger;
  static const Color info = darkAccentCyan;

  // Category Colors
  static const Color categoryAcademic = Color(0xFF5B8CFF);
  static const Color categoryCareer = Color(0xFF10B981);
  static const Color categoryProject = Color(0xFF8B5CF6);
  static const Color categoryPersonal = Color(0xFFF59E0B);
  static const Color categoryOther = Color(0xFF6B7280);

  // Status Colors
  static const Color statusPresent = Color(0xFF4ADE80);
  static const Color statusAbsent = Color(0xFFF87171);
  static const Color statusLate = Color(0xFFFBBF24);
  static const Color statusCancelled = Color(0xFF6B7280);

  // Priority Colors
  static const Color priorityLow = Color(0xFF4ADE80);
  static const Color priorityMedium = Color(0xFFFBBF24);
  static const Color priorityHigh = Color(0xFFF87171);
  static const Color priorityUrgent = Color(0xFFEF4444);

  // Deep Navy Legacy Aliases
  static const Color navyDeep = darkBackground;
  static const Color navySecondary = darkSecondaryBackground;
  static const Color navyCard = darkCard;
  static const Color navyElevated = darkElevatedCard;
  static const Color navyBorder = darkBorder;
  static const Color navySubtle = Color(0xFF22252A);
  static const Color bluePrimary = darkPrimary;
  static const Color blueSecondary = darkPrimaryLight;
  static const Color blueAccent = darkPrimary;
  static const Color blueCyan = darkAccentCyan;
  static const Color blueElectric = darkPrimaryLight;
  static const Color blueGlow = Color(0x405B8CFF);
  static const Color glowCyan = Color(0x4038BDF8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B8CFF), Color(0xFF3B6FE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleCardGradient = LinearGradient(
    colors: [Color(0xFF1E2024), Color(0xFF181A1D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGlowGradient = LinearGradient(
    colors: [Color(0xFF5B8CFF), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient careerGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dynamically fetch the current theme palette based on [BuildContext]
  static AppColorPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorPalette.dark : AppColorPalette.light;
  }
}
