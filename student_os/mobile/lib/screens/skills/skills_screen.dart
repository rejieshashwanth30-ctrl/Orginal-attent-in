import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/skill.dart';
import '../../services/skill_service.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  List<Skill> _skills = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await SkillService.getSkills();
    if (res.success && res.data != null) {
      setState(() {
        _skills = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load skills';
        _isLoading = false;
      });
    }
  }

  void _openSkillEditor(BuildContext context, {Skill? skillToEdit}) {
    final colors = AppColors.of(context);
    final nameCtrl = TextEditingController(text: skillToEdit?.name ?? '');
    int proficiency = skillToEdit?.proficiency ?? 75;
    String category = skillToEdit?.category ?? 'TECHNICAL';

    AppBottomSheet.show(
      context,
      title: skillToEdit == null ? 'Add New Skill' : 'Edit Skill Proficiency',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: nameCtrl,
                label: 'Skill Name',
                hint: 'e.g. Flutter / Dart / PyTorch',
                prefixIcon: Icons.star_border_rounded,
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Proficiency Level', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                  Text(
                    '$proficiency%',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: proficiency.toDouble(),
                min: 10,
                max: 100,
                divisions: 18,
                activeColor: colors.primary,
                onChanged: (val) => setSheetState(() => proficiency = val.round()),
              ),
              const SizedBox(height: 12),
              Text('Category', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.elevatedCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category,
                    isExpanded: true,
                    dropdownColor: colors.card,
                    items: ['TECHNICAL', 'SOFT', 'TOOL'].map((c) {
                      return DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12, color: colors.primaryText)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => category = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: skillToEdit == null ? 'Add Skill to Matrix' : 'Update Skill',
                width: double.infinity,
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  if (skillToEdit == null) {
                    await SkillService.addSkill(
                      name: nameCtrl.text.trim(),
                      proficiency: proficiency,
                      category: category,
                    );
                  } else {
                    await SkillService.updateSkill(
                      id: skillToEdit.id,
                      name: nameCtrl.text.trim(),
                      proficiency: proficiency,
                      category: category,
                    );
                  }

                  if (context.mounted) _fetchSkills();
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Skills Matrix'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: colors.primary),
            tooltip: 'Add Skill',
            onPressed: () => _openSkillEditor(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchSkills,
          child: _isLoading
              ? const AppLoading(message: 'Loading skill proficiency...')
              : _error != null
                  ? AppError(message: _error!, onRetry: _fetchSkills)
                  : _skills.isEmpty
                      ? AppEmptyState(
                          icon: Icons.star_border_rounded,
                          title: 'No Skills Logged',
                          description: 'Track your programming languages, frameworks, and tools.',
                          actionText: '+ Add Skill',
                          onAction: () => _openSkillEditor(context),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          itemCount: _skills.length,
                          itemBuilder: (context, index) {
                            final skill = _skills[index];

                            Color barColor;
                            if (skill.proficiency >= 85) {
                              barColor = colors.success;
                            } else if (skill.proficiency >= 70) {
                              barColor = colors.primary;
                            } else {
                              barColor = colors.warning;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                onTap: () => _openSkillEditor(context, skillToEdit: skill),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              skill.name,
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: colors.primaryText,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: barColor.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                skill.category,
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: barColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${skill.proficiency}%',
                                              style: GoogleFonts.outfit(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: barColor,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, size: 18),
                                              color: colors.mutedText,
                                              onPressed: () async {
                                                await SkillService.deleteSkill(skill.id);
                                                _fetchSkills();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: skill.proficiency / 100.0,
                                        minHeight: 8,
                                        backgroundColor: colors.elevatedCard,
                                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
