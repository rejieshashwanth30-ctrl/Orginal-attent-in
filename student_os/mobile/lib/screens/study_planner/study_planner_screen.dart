import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/study_planner_provider.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/section_header.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyPlannerProvider>().fetchStudyPlan();
    });
  }

  void _openGeneratePlanSheet(BuildContext context) {
    final colors = AppColors.of(context);
    final titleCtrl = TextEditingController(text: 'Finals Acceleration Strategy');
    final hoursCtrl = TextEditingController(text: '3.5');
    final weakCtrl = TextEditingController(text: 'Mathematics IV, AI Algorithms');
    String preferredTime = 'EVENING';
    DateTime targetDate = DateTime.now().add(const Duration(days: 30));

    AppBottomSheet.show(
      context,
      title: 'Generate Intelligent Study Plan',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: titleCtrl,
                label: 'Plan Title',
                hint: 'e.g. Semester End Mastery Plan',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: hoursCtrl,
                      label: 'Daily Hours',
                      hint: '3.5',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preferred Slot', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: colors.elevatedCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: preferredTime,
                              isExpanded: true,
                              dropdownColor: colors.card,
                              items: ['MORNING', 'AFTERNOON', 'EVENING', 'NIGHT'].map((t) {
                                return DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.inter(fontSize: 11, color: colors.primaryText)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => preferredTime = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: weakCtrl,
                label: 'Weak Subjects (Prioritized)',
                hint: 'Mathematics, AI, Computer Networks',
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Generate AI Schedule',
                width: double.infinity,
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final ok = await context.read<StudyPlannerProvider>().generatePlan(
                    title: titleCtrl.text.trim(),
                    targetDate: targetDate,
                    availableHoursDaily: double.tryParse(hoursCtrl.text) ?? 3.0,
                    weakSubjects: weakCtrl.text.trim(),
                    preferredTime: preferredTime,
                  );
                  if (context.mounted && ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Study schedule generated successfully!')),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<StudyPlannerProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('AI Study Planner'),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome, color: colors.primary),
            tooltip: 'Generate Plan',
            onPressed: () => _openGeneratePlanSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchStudyPlan(),
          child: provider.isLoading && provider.plan == null
              ? const AppLoading(message: 'Generating study analytics...')
              : provider.error != null && provider.plan == null
                  ? AppError(message: provider.error!, onRetry: () => provider.fetchStudyPlan())
                  : provider.plan == null
                      ? AppEmptyState(
                          icon: Icons.model_training_outlined,
                          title: 'No Active Study Plan',
                          description: 'Let ATTENT-IN AI generate a custom timetable based on your exam dates and weak subjects.',
                          actionText: '+ Generate Plan',
                          onAction: () => _openGeneratePlanSheet(context),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          children: [
                            // Plan Header Card
                            AppCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          provider.plan!.title,
                                          style: GoogleFonts.outfit(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: colors.primaryText,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: colors.primary.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${provider.plan!.availableHoursDaily} hrs/day',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Focusing on: ${provider.plan!.weakSubjects.isNotEmpty ? provider.plan!.weakSubjects : "All Core Modules"}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: colors.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Overall Completion',
                                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.primaryText),
                                      ),
                                      Text(
                                        '${provider.analytics?.completionPercentage.toStringAsFixed(0) ?? 45}%',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: (provider.analytics?.completionPercentage ?? 45.0) / 100.0,
                                      minHeight: 8,
                                      backgroundColor: colors.elevatedCard,
                                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // FL Chart Subject Distribution Section
                            if (provider.analytics != null && provider.analytics!.subjectDistribution.isNotEmpty) ...[
                              const SectionHeader(title: 'Subject Time Distribution', icon: Icons.pie_chart_outline),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 160,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 28,
                                            sections: _buildPieChartSections(provider.analytics!.subjectDistribution, colors),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: provider.analytics!.subjectDistribution.entries.take(4).map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 6),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: colors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      entry.key,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(fontSize: 11, color: colors.primaryText),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${(entry.value / 60).toStringAsFixed(1)}h',
                                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.secondaryText),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Study Sessions Schedule
                            SectionHeader(
                              title: 'Scheduled Study Sessions',
                              icon: Icons.list_alt_rounded,
                              actionText: '+ Regenerate',
                              onActionTap: () => _openGeneratePlanSheet(context),
                            ),

                            ...provider.plan!.sessions.map((sess) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: sess.isCompleted,
                                        activeColor: colors.success,
                                        onChanged: (_) => provider.toggleSession(sess.id),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sess.subject,
                                              style: GoogleFonts.outfit(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                decoration: sess.isCompleted ? TextDecoration.lineThrough : null,
                                                color: colors.primaryText,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            if (sess.notes != null)
                                              Text(
                                                sess.notes!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: colors.secondaryText,
                                                ),
                                              ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${DateFormat("EEE, MMM d").format(sess.date)} • ${sess.durationMinutes} minutes session',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: colors.mutedText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 40),
                          ],
                        ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, int> distribution, AppColorPalette colors) {
    final chartColors = [colors.primary, colors.secondary, colors.accent, colors.warning, colors.categoryAcademic];
    int idx = 0;

    return distribution.entries.map((e) {
      final color = chartColors[idx % chartColors.length];
      idx++;
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: '${e.value}m',
        radius: 36,
        titleStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        color: color,
      );
    }).toList();
  }
}
