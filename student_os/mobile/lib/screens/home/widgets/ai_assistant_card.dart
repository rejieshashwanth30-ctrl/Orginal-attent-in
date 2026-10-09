import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class AIAssistantCard extends StatelessWidget {
  const AIAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.border,
            width: 1.2,
          ),
          boxShadow: [
            colors.cardShadow,
            BoxShadow(
              color: colors.primary.withValues(alpha: colors.isDark ? 0.16 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            onTap: () => context.push('/ai-assistant'),
            borderRadius: BorderRadius.circular(22),
            splashColor: colors.primary.withValues(alpha: 0.12),
            highlightColor: colors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Tag + AI Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.border,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 13,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AI COPILOT',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // AI Circular Icon with refined glow
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.accentCyan],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.smart_toy_rounded,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Heading Prompts
                  Text(
                    'How can I help you today?',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ask questions, summarize notes, generate quizzes, or organize your semester.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: colors.secondaryText,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Quick Action Chips: Ask AI, Study Plan, Quiz, Notes
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildQuickAction(
                          context,
                          label: 'Ask AI',
                          icon: Icons.chat_bubble_outline_rounded,
                          route: '/ai-assistant',
                        ),
                        const SizedBox(width: 8),
                        _buildQuickAction(
                          context,
                          label: 'Study Plan',
                          icon: Icons.calendar_today_outlined,
                          route: '/study-planner',
                        ),
                        const SizedBox(width: 8),
                        _buildQuickAction(
                          context,
                          label: 'Quiz',
                          icon: Icons.quiz_outlined,
                          route: '/quiz',
                        ),
                        const SizedBox(width: 8),
                        _buildQuickAction(
                          context,
                          label: 'Notes',
                          icon: Icons.edit_note_rounded,
                          route: '/notes',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
  }) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: colors.elevatedCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: colors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
