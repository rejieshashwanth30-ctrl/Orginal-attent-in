import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/attendance_calculator.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/ai/ai_insight_card.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/section_header.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Custom calculator interactive state
  int _calcPresent = 18;
  int _calcTotal = 24;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchAttendance();
    });
  }

  void _openMarkAttendanceSheet(BuildContext context, {String? defaultSubjectId}) {
    final colors = AppColors.of(context);
    final provider = context.read<AttendanceProvider>();
    final subjects = provider.summary?.subjects ?? [];
    if (subjects.isEmpty) return;

    String selectedSubId = defaultSubjectId ?? subjects.first.subjectId;
    String selectedStatus = 'PRESENT';
    DateTime selectedDate = DateTime.now();
    final remarksController = TextEditingController();

    AppBottomSheet.show(
      context,
      title: 'Mark Class Attendance',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.elevatedCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSubId,
                    isExpanded: true,
                    dropdownColor: colors.card,
                    items: subjects.map((s) {
                      return DropdownMenuItem(
                        value: s.subjectId,
                        child: Text('${s.subjectName} (${s.subjectCode})', style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedSubId = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Status',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setSheetState(() => selectedStatus = 'PRESENT'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedStatus == 'PRESENT'
                              ? colors.primary.withValues(alpha: 0.12)
                              : colors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedStatus == 'PRESENT' ? colors.primary : colors.border,
                            width: selectedStatus == 'PRESENT' ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 18,
                                color: selectedStatus == 'PRESENT' ? colors.primary : colors.mutedText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Present',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selectedStatus == 'PRESENT' ? colors.primary : colors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => setSheetState(() => selectedStatus = 'ABSENT'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedStatus == 'ABSENT'
                              ? colors.danger.withValues(alpha: 0.12)
                              : colors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedStatus == 'ABSENT' ? colors.danger : colors.border,
                            width: selectedStatus == 'ABSENT' ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: selectedStatus == 'ABSENT' ? colors.danger : colors.mutedText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Absent',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selectedStatus == 'ABSENT' ? colors.danger : colors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                'Remarks (Optional)',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(hintText: 'e.g. Regular Lecture, Lab Class'),
                style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
              ),

              const SizedBox(height: 20),

              AppButton(
                text: 'Save Attendance Record',
                width: double.infinity,
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final ok = await provider.markAttendance(
                    subjectId: selectedSubId,
                    date: selectedDate,
                    status: selectedStatus,
                    remarks: remarksController.text.trim(),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok ? 'Attendance marked successfully!' : 'Failed to mark attendance'),
                      ),
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
    final attProvider = context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Attendance Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_outlined),
            tooltip: 'Mark Attendance',
            onPressed: () => _openMarkAttendanceSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: colors.primary,
          backgroundColor: colors.card,
          onRefresh: () => attProvider.fetchAttendance(),
          child: attProvider.isLoading && attProvider.summary == null
              ? const AppLoading(message: 'Calculating attendance metrics...')
              : attProvider.error != null && attProvider.summary == null
                  ? AppError(
                      message: attProvider.error!,
                      onRetry: () => attProvider.fetchAttendance(),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      children: [
                        // AI Attendance Prediction & Risk Insight
                        const AIInsightCard(
                          title: 'AI Attendance Strategy',
                          insight:
                              'Your aggregate attendance is currently 81.4%. You can safely miss 2 classes without dropping below the mandatory 75% cutoff. Attend next 3 Compiler Lab sessions to secure an 85% distinction buffer.',
                          riskLevel: 'LOW RISK',
                          metricValue: '81.4%',
                          metricLabel: 'Safe Buffer Active',
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 16),

                        // Top Overall Attendance Card
                        if (attProvider.summary != null) ...[
                          AppCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Overall Aggregate',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: colors.secondaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${attProvider.summary!.overallPercentage.toStringAsFixed(1)}%',
                                          style: GoogleFonts.outfit(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                            color: colors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: attProvider.summary!.overallPercentage < 75
                                            ? colors.danger.withValues(alpha: 0.12)
                                            : colors.success.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: attProvider.summary!.overallPercentage < 75
                                              ? colors.danger.withValues(alpha: 0.4)
                                              : colors.success.withValues(alpha: 0.4),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Text(
                                        attProvider.summary!.overallPercentage < 75 ? '⚠️ SHORTAGE' : '✓ ELIGIBLE',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: attProvider.summary!.overallPercentage < 75
                                              ? colors.danger
                                              : colors.success,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: attProvider.summary!.overallPercentage / 100.0,
                                    minHeight: 8,
                                    backgroundColor: colors.elevatedCard,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      attProvider.summary!.overallPercentage < 75
                                          ? colors.danger
                                          : colors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${attProvider.summary!.attendedClasses} attended of ${attProvider.summary!.totalClasses} total',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: colors.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AttendanceCalculator.getStatusMessage(
                                        attProvider.summary!.attendedClasses,
                                        attProvider.summary!.totalClasses,
                                      ),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: attProvider.summary!.overallPercentage < 75
                                            ? colors.danger
                                            : colors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        // Interactive Attendance Calculator Widget
                        AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calculate_outlined, size: 20, color: colors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Attendance Target Calculator',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Classes Attended: $_calcPresent', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                                        Slider(
                                          value: _calcPresent.toDouble(),
                                          min: 0,
                                          max: _calcTotal.toDouble(),
                                          divisions: _calcTotal > 0 ? _calcTotal : 1,
                                          activeColor: colors.primary,
                                          inactiveColor: colors.elevatedCard,
                                          onChanged: (val) => setState(() => _calcPresent = val.round()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Classes: $_calcTotal', style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText)),
                                        Slider(
                                          value: _calcTotal.toDouble(),
                                          min: 10,
                                          max: 80,
                                          activeColor: colors.secondaryText,
                                          inactiveColor: colors.elevatedCard,
                                          onChanged: (val) {
                                            setState(() {
                                              _calcTotal = val.round();
                                              if (_calcPresent > _calcTotal) _calcPresent = _calcTotal;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.elevatedCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: colors.border, width: 0.8),
                                ),
                                child: Text(
                                  'Result (${AttendanceCalculator.calculatePercentage(_calcPresent, _calcTotal).toStringAsFixed(1)}%): '
                                  '${AttendanceCalculator.getStatusMessage(_calcPresent, _calcTotal)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Subject-wise Breakdown Header
                        SectionHeader(
                          title: 'Subject-wise Breakdown',
                          icon: Icons.list_alt_rounded,
                          actionText: '+ Mark Class',
                          onActionTap: () => _openMarkAttendanceSheet(context),
                        ),

                        if (attProvider.summary != null && attProvider.summary!.subjects.isNotEmpty)
                          ...attProvider.summary!.subjects.map((sub) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AttendanceCard(
                                subjectAttendance: sub,
                                onMarkAttendance: () => _openMarkAttendanceSheet(context, defaultSubjectId: sub.subjectId),
                              ),
                            );
                          })
                        else
                          const AppEmptyState(
                            title: 'No Subject Attendance Found',
                            description: 'Enrolled subjects and attendance logs will appear here.',
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
        ),
      ),
    );
  }
}
