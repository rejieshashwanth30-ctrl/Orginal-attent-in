import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cgpa_provider.dart';
import '../../widgets/ai/ai_copilot_button.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  State<CgpaScreen> createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final _targetCgpaController = TextEditingController(text: '9.0');
  final _remainingCreditsController = TextEditingController(text: '24');
  double? _targetRequiredGpa;

  @override
  void dispose() {
    _targetCgpaController.dispose();
    _remainingCreditsController.dispose();
    super.dispose();
  }

  void _openAddSubjectModal(BuildContext context, CgpaProvider provider) {
    final colors = AppColors.of(context);
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final credCtrl = TextEditingController(text: '4');
    String selectedGrade = 'A';

    AppBottomSheet.show(
      context,
      title: 'Add Subject to ${provider.currentSemester.semesterName}',
      child: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            children: [
              AppTextField(
                controller: nameCtrl,
                label: 'Subject Name',
                hint: 'e.g. Artificial Intelligence',
                prefixIcon: Icons.menu_book_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: codeCtrl,
                label: 'Subject Code',
                hint: 'e.g. CSE506',
                prefixIcon: Icons.tag_rounded,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: credCtrl,
                      label: 'Credits (1 - 6)',
                      hint: '4',
                      prefixIcon: Icons.straighten_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Grade', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedGrade,
                              isExpanded: true,
                              dropdownColor: colors.card,
                              items: ['S', 'A', 'B', 'C', 'D', 'E', 'F'].map((g) {
                                return DropdownMenuItem(
                                  value: g,
                                  child: Text(
                                    '$g (${provider.gradingScale.scale[g] ?? 0.0} pts)',
                                    style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedGrade = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Save Subject',
                width: double.infinity,
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  final credits = int.tryParse(credCtrl.text) ?? 3;
                  provider.addSubjectToCurrentSemester(
                    name: nameCtrl.text.trim(),
                    code: codeCtrl.text.trim().isEmpty ? 'SUB101' : codeCtrl.text.trim(),
                    credits: credits,
                    grade: selectedGrade,
                  );
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPredictionSimulation(BuildContext context, CgpaProvider provider) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String gradeSub1 = 'S';
        String gradeSub2 = 'A';
        String gradeSub3 = 'S';

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final simulatedCgpa = provider.simulateFutureCgpa([
              {'credits': 4, 'grade': gradeSub1},
              {'credits': 4, 'grade': gradeSub2},
              {'credits': 3, 'grade': gradeSub3},
            ]);

            return Container(
              height: MediaQuery.of(modalCtx).size.height * 0.75,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: colors.border, width: 1)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.border, width: 1),
                        ),
                        child: Icon(Icons.auto_graph_outlined, color: colors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI CGPA Simulator',
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: colors.primaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Simulate upcoming semester grades and observe projected impacts on your cumulative CGPA.',
                    style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.elevatedCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text('PREDICTED CUMULATIVE CGPA', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primary)),
                        const SizedBox(height: 4),
                        Text(
                          simulatedCgpa.toStringAsFixed(2),
                          style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold, color: colors.primaryText),
                        ),
                        Text(
                          'Based on current + 11 simulated upcoming credits',
                          style: GoogleFonts.inter(fontSize: 11.5, color: colors.mutedText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSimGradeSelector('Machine Learning (4 Credits)', gradeSub1, (val) => setModalState(() => gradeSub1 = val), colors),
                  const SizedBox(height: 10),
                  _buildSimGradeSelector('Compiler Design (4 Credits)', gradeSub2, (val) => setModalState(() => gradeSub2 = val), colors),
                  const SizedBox(height: 10),
                  _buildSimGradeSelector('Cloud Computing (3 Credits)', gradeSub3, (val) => setModalState(() => gradeSub3 = val), colors),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border, width: 0.8),
                    ),
                    child: Text(
                      'Note: Predictions are mathematically modeled estimates based on standard university credit weightings.',
                      style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSimGradeSelector(String label, String currentGrade, ValueChanged<String> onChanged, AppColorPalette colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colors.elevatedCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentGrade,
              dropdownColor: colors.card,
              items: ['S', 'A', 'B', 'C', 'D', 'E', 'F'].map((g) {
                return DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary)));
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<CgpaProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'CGPA Calculator & AI Predictor',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.primaryText,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AICopilotButton(
              label: 'AI Predict',
              icon: Icons.auto_awesome,
              onPressed: () => _openPredictionSimulation(context, provider),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Overall CGPA Hero Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.border, width: 1),
              boxShadow: [
                colors.cardShadow,
              ],
            ),
            child: Column(
              children: [
            ),
          ),
          const SizedBox(height: 18),

          // 2. Target CGPA Calculator Section
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.track_changes_outlined, size: 18, color: colors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Target CGPA Goal Solver',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: colors.primaryText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, size: 18, color: colors.secondaryText),
                      onPressed: () {
                        final target = double.tryParse(_targetCgpaController.text) ?? 9.0;
                        final remCred = int.tryParse(_remainingCreditsController.text) ?? 24;
                        setState(() {
                          _targetRequiredGpa = provider.calculateRequiredGpaForTarget(
                            targetCgpa: target,
                            remainingCredits: remCred,
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Calculate exact average GPA required across upcoming credits to graduate with target honors.',
                  style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _targetCgpaController,
                        label: 'Target CGPA',
                        hint: '9.0',
                        prefixIcon: Icons.flag_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _remainingCreditsController,
                        label: 'Remaining Credits',
                        hint: '24',
                        prefixIcon: Icons.straighten_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppButton(
                  text: 'Compute Target Requirement',
                  width: double.infinity,
                  type: AppButtonType.secondary,
                  onPressed: () {
                    final target = double.tryParse(_targetCgpaController.text) ?? 9.0;
                    final remCred = int.tryParse(_remainingCreditsController.text) ?? 24;
                    setState(() {
                      _targetRequiredGpa = provider.calculateRequiredGpaForTarget(
                        targetCgpa: target,
                        remainingCredits: remCred,
                      );
                    });
                  },
                ),
                if (_targetRequiredGpa != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.elevatedCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Required Average GPA:', style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText)),
                        Text(
                          '${_targetRequiredGpa!.toStringAsFixed(2)} / 10.0',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 3. Semester Tabs & Live Subjects Editor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SEMESTER BREAKDOWN',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.primaryText),
              ),
              InkWell(
                onTap: () => _openAddSubjectModal(context, provider),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 14, color: colors.primary),
                      const SizedBox(width: 4),
                      Text('+ Add Subject', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Semester selection chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: provider.semesters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final sem = provider.semesters[i];
                final isSel = provider.selectedSemesterIndex == i;
                return ChoiceChip(
                  label: Text(
                    'Sem ${sem.semesterNumber} (${sem.semesterGpa})',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      color: isSel ? Colors.white : colors.secondaryText,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: colors.primary,
                  backgroundColor: colors.card,
                  side: BorderSide(color: isSel ? colors.primary : colors.border),
                  onSelected: (_) => provider.setSelectedSemester(i),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Subject cards in selected semester
          ...provider.currentSemester.subjects.map((sub) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border, width: 0.8),
                      ),
                      child: Text(
                        '${sub.credits}C',
                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: colors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub.subjectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.primaryText),
                          ),
                          Text(
                            '${sub.subjectCode} • ${sub.gradePoint} Grade Points',
                            style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border, width: 0.8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: sub.grade,
                          dropdownColor: colors.card,
                          items: ['S', 'A', 'B', 'C', 'D', 'E', 'F'].map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primary)),
                            );
                          }).toList(),
                          onChanged: (newGrade) {
                            if (newGrade != null) {
                              provider.updateSubjectGrade(provider.selectedSemesterIndex, sub.id, newGrade);
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 16, color: colors.mutedText),
                      onPressed: () => provider.deleteSubject(provider.selectedSemesterIndex, sub.id),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroMetric(String label, String value, AppColorPalette colors) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: colors.primaryText)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
      ],
    );
  }
}
