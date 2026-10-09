import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/date_extensions.dart';
import '../../models/calendar_event.dart';
import '../../services/calendar_service.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  List<CalendarEventModel> _allEvents = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'ALL';

  final List<String> _categories = ['ALL', 'CLASS', 'ASSIGNMENT', 'EXAM', 'TASK', 'HACKATHON', 'INTERNSHIP', 'OTHER'];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await CalendarService.getEvents();
    if (res.success && res.data != null) {
      setState(() {
        _allEvents = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load calendar';
        _isLoading = false;
      });
    }
  }

  List<CalendarEventModel> get _filteredEvents {
    var list = _allEvents;
    if (_selectedCategory != 'ALL') {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }
    return list;
  }

  List<CalendarEventModel> get _selectedDayEvents {
    return _filteredEvents.where((e) => e.startTime.isSameDay(_selectedDate)).toList();
  }

  void _openAddEventSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    DateTime eventDate = _selectedDate;
    String category = 'OTHER';

    AppBottomSheet.show(
      context,
      title: 'Add Calendar Event',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          final sheetColors = AppColors.of(ctx);

          return Column(
            children: [
              AppTextField(
                controller: titleCtrl,
                label: 'Event Title',
                hint: 'e.g. ML Project Milestone Demo',
                prefixIcon: Icons.event,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: descCtrl,
                label: 'Description',
                hint: 'Notes & agenda',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: locCtrl,
                label: 'Location / Link',
                hint: 'Room 101 or Google Meet',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: sheetColors.primaryText)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: sheetColors.elevatedCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sheetColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: category,
                              isExpanded: true,
                              dropdownColor: sheetColors.card,
                              items: ['CLASS', 'ASSIGNMENT', 'EXAM', 'TASK', 'HACKATHON', 'INTERNSHIP', 'OTHER'].map((c) {
                                return DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12, color: sheetColors.primaryText)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => category = val);
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
                        Text('Date', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: sheetColors.primaryText)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: eventDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setSheetState(() => eventDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: sheetColors.elevatedCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sheetColors.border),
                            ),
                            child: Text(DateFormat('MMM d, yyyy').format(eventDate), style: GoogleFonts.inter(fontSize: 13, color: sheetColors.primaryText)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Save Event',
                width: double.infinity,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  final res = await CalendarService.createEvent(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    location: locCtrl.text.trim(),
                    startTime: eventDate,
                    category: category,
                  );

                  if (context.mounted && res.success) {
                    _fetchEvents();
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Academic Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: colors.primary),
            tooltip: 'Add Event',
            onPressed: () => _openAddEventSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const AppLoading(message: 'Loading events & deadlines...')
            : _error != null
                ? AppError(message: _error!, onRetry: _fetchEvents)
                : Column(
                    children: [
                      // Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  cat,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : colors.primaryText,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: colors.primary,
                                backgroundColor: colors.card,
                                side: BorderSide(color: isSelected ? colors.primary : colors.border),
                                onSelected: (_) => setState(() => _selectedCategory = cat),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Horizontal 14-Day Date Selector Strip
                      Container(
                        height: 76,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 14,
                          itemBuilder: (context, index) {
                            final date = DateTime.now().add(Duration(days: index - 2));
                            final isSelected = date.isSameDay(_selectedDate);

                            return GestureDetector(
                              onTap: () => setState(() => _selectedDate = date),
                              child: Container(
                                width: 56,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.card,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? colors.primary
                                        : colors.border,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('EEE').format(date).toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : colors.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${date.day}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : colors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Selected Day Events List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _fetchEvents,
                          child: _selectedDayEvents.isEmpty
                              ? AppEmptyState(
                                  icon: Icons.event_available_outlined,
                                  title: 'No Events for ${DateFormat('MMM d').format(_selectedDate)}',
                                  description: 'Classes, assignments, exams, or hackathons scheduled for this day will appear here.',
                                  actionText: '+ Add Custom Event',
                                  onAction: () => _openAddEventSheet(context),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  itemCount: _selectedDayEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = _selectedDayEvents[index];

                                    Color catColor;
                                    switch (event.category) {
                                      case 'ASSIGNMENT':
                                        catColor = colors.primary;
                                        break;
                                      case 'EXAM':
                                        catColor = colors.danger;
                                        break;
                                      case 'HACKATHON':
                                        catColor = colors.warning;
                                        break;
                                      case 'INTERNSHIP':
                                        catColor = colors.success;
                                        break;
                                      default:
                                        catColor = colors.secondary;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: AppCard(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: catColor.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(Icons.event_note, color: catColor, size: 20),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: catColor.withValues(alpha: 0.12),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          event.category,
                                                          style: GoogleFonts.inter(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                            color: catColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        event.startTime.toTimeString(),
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11,
                                                          color: colors.secondaryText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    event.title,
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      color: colors.primaryText,
                                                    ),
                                                  ),
                                                  if (event.description != null && event.description!.isNotEmpty) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      event.description!,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: colors.secondaryText,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            if (event.originalId == null)
                                              IconButton(
                                                icon: const Icon(Icons.close, size: 16),
                                                color: colors.mutedText,
                                                onPressed: () async {
                                                  await CalendarService.deleteEvent(event.id);
                                                  _fetchEvents();
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
