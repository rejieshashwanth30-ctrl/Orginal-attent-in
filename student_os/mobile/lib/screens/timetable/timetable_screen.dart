import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../models/timetable.dart';
import '../../services/api_service.dart';
import '../../widgets/ai/ai_insight_card.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  Map<String, List<TimetableSlot>> _timetable = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Default tab to current day
    final dayIndex = DateTime.now().weekday - 1;
    _tabController = TabController(
      length: _days.length,
      vsync: this,
      initialIndex: (dayIndex >= 0 && dayIndex < _days.length) ? dayIndex : 0,
    );
    _fetchTimetable();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTimetable() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await ApiService.get(ApiConstants.timetable, cacheKey: 'timetable_data');

    if (res.success && res.data != null) {
      final Map<String, List<TimetableSlot>> parsed = {};
      final map = res.data as Map<String, dynamic>;
      for (final day in _days) {
        if (map[day] != null) {
          parsed[day] = (map[day] as List)
              .map((s) => TimetableSlot.fromJson(s))
              .toList();
        } else {
          parsed[day] = [];
        }
      }
      setState(() {
        _timetable = parsed;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load timetable';
        _isLoading = false;
      });
    }
  }

  void _openAddSlotSheet(BuildContext context, String dayOfWeek, {TimetableSlot? slotToEdit}) {
    final subNameCtrl = TextEditingController(text: slotToEdit?.subjectName ?? '');
    final facultyCtrl = TextEditingController(text: slotToEdit?.faculty ?? '');
    final roomCtrl = TextEditingController(text: slotToEdit?.room ?? '');
    final startCtrl = TextEditingController(text: slotToEdit?.startTime ?? '09:00 AM');
    final endCtrl = TextEditingController(text: slotToEdit?.endTime ?? '10:00 AM');

    AppBottomSheet.show(
      context,
      title: slotToEdit == null ? 'Add Class to $dayOfWeek' : 'Edit Class Slot',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            children: [
              AppTextField(
                controller: subNameCtrl,
                label: 'Subject Name',
                hint: 'e.g. Machine Learning',
                prefixIcon: Icons.menu_book_outlined,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: roomCtrl,
                      label: 'Room / Lab',
                      hint: 'Room A204',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: facultyCtrl,
                      label: 'Faculty',
                      hint: 'Dr. Johnson',
                      prefixIcon: Icons.person_outline,
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
                      hint: '09:00 AM',
                      prefixIcon: Icons.access_time_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: endCtrl,
                      label: 'End Time',
                      hint: '10:00 AM',
                      prefixIcon: Icons.access_time_filled_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                text: slotToEdit == null ? 'Add Schedule Slot' : 'Update Slot',
                width: double.infinity,
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  if (subNameCtrl.text.trim().isEmpty) return;

                  if (slotToEdit == null) {
                    // Create slot
                    await ApiService.post(
                      ApiConstants.timetable,
                      body: {
                        'subjectId': slotToEdit?.subjectId ?? 'new-sub',
                        'dayOfWeek': dayOfWeek,
                        'startTime': startCtrl.text.trim(),
                        'endTime': endCtrl.text.trim(),
                        'room': roomCtrl.text.trim(),
                        'faculty': facultyCtrl.text.trim(),
                      },
                    );
                    if (context.mounted) {
                      _fetchTimetable();
                    }
                  } else {
                    // Update slot
                    await ApiService.put(
                      '${ApiConstants.timetable}/${slotToEdit.id}',
                      body: {
                        'dayOfWeek': dayOfWeek,
                        'startTime': startCtrl.text.trim(),
                        'endTime': endCtrl.text.trim(),
                        'room': roomCtrl.text.trim(),
                        'faculty': facultyCtrl.text.trim(),
                      },
                    );
                    if (context.mounted) {
                      _fetchTimetable();
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteSlot(String slotId) async {
    await ApiService.delete('${ApiConstants.timetable}/$slotId');
    _fetchTimetable();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: colors.primaryText,
          indicatorColor: colors.primary,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: _days.map((d) => Tab(text: d)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Class',
            onPressed: () {
              final activeDay = _days[_tabController.index];
              _openAddSlotSheet(context, activeDay);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const AppLoading(message: 'Loading timetable schedule...')
            : _error != null
                ? AppError(message: _error!, onRetry: _fetchTimetable)
                : TabBarView(
                    controller: _tabController,
                    children: _days.map((day) {
                      final slots = _timetable[day] ?? [];
                      if (slots.isEmpty) {
                        return AppEmptyState(
                          icon: Icons.free_breakfast_outlined,
                          title: 'No Classes on $day',
                          description: 'You have no scheduled lectures or labs on this day.',
                          actionText: '+ Add Class Slot',
                          onAction: () => _openAddSlotSheet(context, day),
                        );
                      }

                      return RefreshIndicator(
                        color: colors.primary,
                        backgroundColor: colors.card,
                        onRefresh: _fetchTimetable,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          itemCount: slots.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: AIInsightCard(
                                  title: 'AI Schedule Optimization',
                                  insight:
                                      'You have a 1-hour free study window between 11:30 AM and 12:30 PM. Recommended: Use this slot for Compiler Design parser code review before afternoon lab.',
                                  riskLevel: 'FREE PERIOD DETECTED',
                                  metricValue: '1 hr Free',
                                  metricLabel: 'Study Opportunity',
                                  icon: Icons.access_time_filled_rounded,
                                ),
                              );
                            }
                            final slot = slots[index - 1];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Time Column
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          slot.startTime,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.primaryText,
                                          ),
                                        ),
                                        Text(
                                          slot.endTime,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: colors.mutedText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 14),
                                    // Vertical accent bar
                                    Container(
                                      width: 3,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: colors.primary.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Subject & details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            slot.subjectName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.outfit(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: colors.primaryText,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_outlined, size: 13, color: colors.mutedText),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  slot.room,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                                                ),
                                              ),
                                              if (slot.faculty != null) ...[
                                                const SizedBox(width: 10),
                                                Icon(Icons.person_outline, size: 13, color: colors.mutedText),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    slot.faculty!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Actions Menu
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert, size: 18, color: colors.secondaryText),
                                      color: colors.card,
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                          _openAddSlotSheet(context, day, slotToEdit: slot);
                                        } else if (val == 'delete') {
                                          _deleteSlot(slot.id);
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: colors.primaryText))),
                                        PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: colors.secondaryText))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}
