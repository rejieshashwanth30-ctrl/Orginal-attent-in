import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/assignment_provider.dart';
import '../../widgets/ai/ai_insight_card.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/assignment_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _filters = ['ALL', 'PENDING', 'IN_PROGRESS', 'COMPLETED', 'OVERDUE'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<AssignmentProvider>().setFilter(_filters[_tabController.index]);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentProvider>().fetchAssignments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCreateAssignmentSheet(BuildContext context) {
    final colors = AppColors.of(context);
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final marksCtrl = TextEditingController(text: '100');
    DateTime selectedDate = DateTime.now().add(const Duration(days: 4));
    String selectedPriority = 'MEDIUM';

    AppBottomSheet.show(
      context,
      title: 'New Assignment',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: titleCtrl,
                label: 'Assignment Title',
                hint: 'e.g. Backpropagation Algorithm Implementation',
                prefixIcon: Icons.assignment_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: descCtrl,
                label: 'Description / Instructions',
                hint: 'Specific module criteria & requirements',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Priority', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
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
                              value: selectedPriority,
                              isExpanded: true,
                              dropdownColor: colors.card,
                              items: ['LOW', 'MEDIUM', 'HIGH'].map((p) {
                                return DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => selectedPriority = val);
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
                        Text('Due Date', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setSheetState(() => selectedDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: colors.elevatedCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.event_outlined, size: 16, color: colors.primaryText),
                                const SizedBox(width: 6),
                                Text(DateFormat('MMM d').format(selectedDate), style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)),
                              ],
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
                text: 'Create Assignment',
                width: double.infinity,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  final ok = await context.read<AssignmentProvider>().createAssignment(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    dueDate: selectedDate,
                    priority: selectedPriority,
                    maxMarks: int.tryParse(marksCtrl.text) ?? 100,
                  );

                  if (context.mounted && ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Assignment added successfully!')),
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
    final provider = context.watch<AssignmentProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Assignments'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: colors.primaryText,
          indicatorColor: colors.primary,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
            Tab(text: 'Overdue'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'New Assignment',
            onPressed: () => _openCreateAssignmentSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: colors.primary,
          backgroundColor: colors.card,
          onRefresh: () => provider.fetchAssignments(),
          child: provider.isLoading && provider.assignments.isEmpty
              ? const AppLoading(message: 'Loading assignments...')
              : provider.error != null && provider.assignments.isEmpty
                  ? AppError(message: provider.error!, onRetry: () => provider.fetchAssignments())
                  : provider.filteredAssignments.isEmpty
                      ? AppEmptyState(
                          icon: Icons.task_alt_outlined,
                          title: 'No Assignments Found',
                          description: 'No assignments matching "${provider.activeFilter}".',
                          actionText: '+ Add New Assignment',
                          onAction: () => _openCreateAssignmentSheet(context),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          itemCount: provider.filteredAssignments.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: AIInsightCard(
                                  title: 'AI Priority & Deadline Ranking',
                                  insight:
                                      '1. CNN Attention Implementation (Due in 3 days) — High Difficulty\n2. Kubernetes Distributed Cluster Lab (Due in 5 days) — Medium\nEstimated total study time required: 4.5 hours.',
                                  riskLevel: 'PRIORITY QUEUE',
                                  icon: Icons.assignment_turned_in_outlined,
                                ),
                              );
                            }
                            final asgn = provider.filteredAssignments[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AssignmentCard(
                                assignment: asgn,
                                onStatusToggle: (checked) {
                                  final newStatus = (checked == true) ? 'COMPLETED' : 'PENDING';
                                  provider.updateStatus(asgn.id, newStatus);
                                },
                                onDelete: () => provider.deleteAssignment(asgn.id),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
