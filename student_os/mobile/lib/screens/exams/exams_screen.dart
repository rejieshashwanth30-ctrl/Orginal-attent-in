import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../services/exam_service.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/exam_card.dart';
import '../../widgets/loading_widget.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  List<Exam> _exams = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchExams();
  }

  Future<void> _fetchExams() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await ExamService.getExams();
    if (res.success && res.data != null) {
      setState(() {
        _exams = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load exams';
        _isLoading = false;
      });
    }
  }

  void _showSyllabusModal(BuildContext context, Exam exam) {
    AppDialog.show(
      context,
      title: '${exam.subjectName} (${exam.type})',
      content: 'Date: ${exam.date.toLocal().toString().split(" ")[0]}\n'
          'Time: ${exam.startTime} - ${exam.endTime}\n'
          'Room: ${exam.room}\n'
          'Max Marks: ${exam.maxMarks}\n\n'
          'Syllabus Coverage:\n${exam.syllabus ?? "Standard university syllabus modules 1 to 5."}',
      confirmText: 'Got It',
      cancelText: 'Close',
    );
  }

  void _openCreateExamSheet(BuildContext context) {
    final subCtrl = TextEditingController();
    final roomCtrl = TextEditingController(text: 'Exam Hall 201');
    final startCtrl = TextEditingController(text: '09:30 AM');
    final endCtrl = TextEditingController(text: '12:30 PM');
    final marksCtrl = TextEditingController(text: '50');
    final syllabusCtrl = TextEditingController();
    String selectedType = 'INTERNAL';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

    AppBottomSheet.show(
      context,
      title: 'Schedule New Exam',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          return Column(
            children: [
              AppTextField(
                controller: subCtrl,
                label: 'Subject Name',
                hint: 'e.g. Artificial Intelligence',
                prefixIcon: Icons.quiz_outlined,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Exam Type', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSecondary : AppColors.lightSurfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedType,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              items: ['INTERNAL', 'MODEL', 'LAB', 'SEMESTER'].map((t) {
                                return DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.inter(fontSize: 12)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => selectedType = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Exam Date', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setSheetState(() => selectedDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceSecondary : AppColors.lightSurfaceSecondary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event, size: 16),
                                const SizedBox(width: 6),
                                Text(DateFormat('MMM d').format(selectedDate), style: GoogleFonts.inter(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: startCtrl,
                      label: 'Start Time',
                      hint: '09:30 AM',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: endCtrl,
                      label: 'End Time',
                      hint: '12:30 PM',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: roomCtrl,
                      label: 'Room / Hall',
                      hint: 'Hall 201',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: marksCtrl,
                      label: 'Max Marks',
                      hint: '50',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: syllabusCtrl,
                label: 'Syllabus Details',
                hint: 'e.g. Units 1 to 3',
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Schedule Exam',
                width: double.infinity,
                onPressed: () async {
                  if (subCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  final res = await ExamService.createExam(
                    subjectName: subCtrl.text.trim(),
                    type: selectedType,
                    date: selectedDate,
                    startTime: startCtrl.text.trim(),
                    endTime: endCtrl.text.trim(),
                    room: roomCtrl.text.trim(),
                    syllabus: syllabusCtrl.text.trim(),
                    maxMarks: int.tryParse(marksCtrl.text) ?? 50,
                  );

                  if (context.mounted && res.success) {
                    _fetchExams();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams & Syllabus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Exam',
            onPressed: () => _openCreateExamSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchExams,
          child: _isLoading
              ? const AppLoading(message: 'Loading exam schedule...')
              : _error != null
                  ? AppError(message: _error!, onRetry: _fetchExams)
                  : _exams.isEmpty
                      ? AppEmptyState(
                          icon: Icons.quiz_outlined,
                          title: 'No Upcoming Exams',
                          description: 'All your exams are completed or not scheduled yet.',
                          actionText: '+ Schedule Exam',
                          onAction: () => _openCreateExamSheet(context),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          itemCount: _exams.length,
                          itemBuilder: (context, index) {
                            final exam = _exams[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ExamCard(
                                exam: exam,
                                onTap: () => _showSyllabusModal(context, exam),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
