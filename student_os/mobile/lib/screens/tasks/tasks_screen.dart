import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/task_provider.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['ALL', 'ACADEMIC', 'CAREER', 'PROJECT', 'PERSONAL', 'OTHER'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCreateTaskSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = 'ACADEMIC';
    String selectedPriority = 'MEDIUM';

    AppBottomSheet.show(
      context,
      title: 'Create New Task',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          return Column(
            children: [
              AppTextField(
                controller: titleCtrl,
                label: 'Task Title',
                hint: 'e.g. Complete LeetCode daily challenge',
                prefixIcon: Icons.task_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: descCtrl,
                label: 'Description (Optional)',
                hint: 'Additional notes or checklist items',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
                              value: selectedCategory,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              items: ['ACADEMIC', 'CAREER', 'PROJECT', 'PERSONAL', 'OTHER'].map((c) {
                                return DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => selectedCategory = val);
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
                        Text('Priority', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
                              value: selectedPriority,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              items: ['LOW', 'MEDIUM', 'HIGH'].map((p) {
                                return DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontSize: 12)));
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
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due Date', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSecondary : AppColors.lightSurfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event, size: 18),
                          const SizedBox(width: 8),
                          Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate), style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Create Task',
                width: double.infinity,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  final ok = await context.read<TaskProvider>().createTask(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    category: selectedCategory,
                    priority: selectedPriority,
                    dueDate: selectedDate,
                  );

                  if (context.mounted && ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added successfully!')),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks & Priorities'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? AppColors.primaryLight : AppColors.primary,
          indicatorColor: isDark ? AppColors.primaryLight : AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Task',
            onPressed: () => _openCreateTaskSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = provider.activeCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      onSelected: (_) => provider.setCategory(cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.fetchTasks(),
                child: provider.isLoading && provider.tasks.isEmpty
                    ? const AppLoading(message: 'Loading tasks...')
                    : provider.error != null && provider.tasks.isEmpty
                        ? AppError(message: provider.error!, onRetry: () => provider.fetchTasks())
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildTaskList(provider.todayTasks, 'No Tasks for Today', 'You have cleared all goals for today!'),
                              _buildTaskList(provider.upcomingTasks, 'No Upcoming Tasks', 'Plan your project milestones and study sessions.'),
                              _buildTaskList(provider.completedTasks, 'No Completed Tasks', 'Completed tasks will be recorded here for your review.'),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List tasks, String emptyTitle, String emptyDesc) {
    if (tasks.isEmpty) {
      return AppEmptyState(
        icon: Icons.done_all_rounded,
        title: emptyTitle,
        description: emptyDesc,
        actionText: '+ Add New Task',
        onAction: () => _openCreateTaskSheet(context),
      );
    }

    final provider = context.read<TaskProvider>();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskCard(
            task: task,
            onToggle: () => provider.toggleTask(task.id),
            onDelete: () => provider.deleteTask(task.id),
          ),
        );
      },
    );
  }
}
