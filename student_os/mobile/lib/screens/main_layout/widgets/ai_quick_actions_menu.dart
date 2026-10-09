import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class AIQuickActionsMenu extends StatefulWidget {
  final VoidCallback onDismiss;
  final Function(int tabIndex)? onSelectTab;

  const AIQuickActionsMenu({
    super.key,
    required this.onDismiss,
    this.onSelectTab,
  });

  static Future<void> show(
    BuildContext context, {
    Function(int tabIndex)? onSelectTab,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AI Quick Actions',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) {
        return AIQuickActionsMenu(
          onDismiss: () => Navigator.of(ctx).pop(),
          onSelectTab: onSelectTab,
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<AIQuickActionsMenu> createState() => _AIQuickActionsMenuState();
}

class _AIQuickActionsMenuState extends State<AIQuickActionsMenu> {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = mathMin(screenWidth * 0.88, 380.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Safe bottom positioned floating popover
            Positioned(
              bottom: 96 + MediaQuery.of(context).padding.bottom,
              child: GestureDetector(
                onTap: () {}, // Prevent dismissal when tapping inside card
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: menuWidth,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.82,
                      ),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.isDark ? const Color(0xEB181A1D) : const Color(0xFAF5F6F8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colors.border,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.isDark
                                ? Colors.black.withValues(alpha: 0.55)
                                : const Color(0xFF171A1F).withValues(alpha: 0.12),
                            blurRadius: 28,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: colors.primary.withValues(alpha: colors.isDark ? 0.25 : 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [colors.primary, colors.accentCyan],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'ATTENT-IN AI CORE',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                        color: colors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.close_rounded, size: 18, color: colors.mutedText),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: widget.onDismiss,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(height: 1, color: colors.border),
                            const SizedBox(height: 12),

                            // Quick Action 1: Ask AI Copilot
                            _buildActionTile(
                              context: context,
                              icon: Icons.smart_toy_rounded,
                              iconGradient: [colors.primary, colors.accentCyan],
                              title: 'Ask AI Copilot',
                              subtitle: 'Instant academic reasoning & doubt clearance',
                              onTap: () {
                                widget.onDismiss();
                                if (widget.onSelectTab != null) {
                                  widget.onSelectTab!(2);
                                } else {
                                  context.push('/ai-assistant');
                                }
                              },
                            ),

                            // Quick Action 2: AI Quiz Generator
                            _buildActionTile(
                              context: context,
                              icon: Icons.quiz_rounded,
                              iconGradient: const [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                              title: 'AI Quiz Generator',
                              subtitle: 'Generate adaptive practice tests from syllabus',
                              onTap: () {
                                widget.onDismiss();
                                context.push('/quiz');
                              },
                            ),

                            // Quick Action 3: AI Flashcards
                            _buildActionTile(
                              context: context,
                              icon: Icons.style_rounded,
                              iconGradient: const [Color(0xFF06B6D4), Color(0xFF10B981)],
                              title: 'AI Flashcards',
                              subtitle: 'Spaced repetition decks from notes & mistakes',
                              onTap: () {
                                widget.onDismiss();
                                context.push('/flashcards');
                              },
                            ),

                            // Quick Action 4: Notes Copilot
                            _buildActionTile(
                              context: context,
                              icon: Icons.edit_note_rounded,
                              iconGradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                              title: 'Notes Copilot',
                              subtitle: 'Ground Q&A and summaries on your class notes',
                              onTap: () {
                                widget.onDismiss();
                                context.push('/notes');
                              },
                            ),

                            // Quick Action 5: AI Study Planner
                            _buildActionTile(
                              context: context,
                              icon: Icons.model_training_rounded,
                              iconGradient: const [Color(0xFF3B82F6), Color(0xFF6366F1)],
                              title: 'AI Study Planner',
                              subtitle: 'Intelligent revision blocks & schedule solver',
                              onTap: () {
                                widget.onDismiss();
                                context.push('/study-planner');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: iconGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.first.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, size: 19, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: colors.mutedText,
            ),
          ],
        ),
      ),
    );
  }

  double mathMin(double a, double b) => a < b ? a : b;
}
