import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/assignment_provider.dart';
import '../../providers/career_provider.dart';
import '../../providers/note_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final asgnProvider = context.watch<AssignmentProvider>();
    final noteProvider = context.watch<NoteProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final careerProvider = context.watch<CareerProvider>();

    final q = _query.toLowerCase().trim();

    final matchingAssignments = q.isEmpty
        ? []
        : asgnProvider.assignments.where((a) => a.title.toLowerCase().contains(q) || a.subjectName.toLowerCase().contains(q)).toList();

    final matchingNotes = q.isEmpty
        ? []
        : noteProvider.notes.where((n) => n.title.toLowerCase().contains(q) || n.content.toLowerCase().contains(q) || n.tags.toLowerCase().contains(q)).toList();

    final matchingTasks = q.isEmpty
        ? []
        : taskProvider.tasks.where((t) => t.title.toLowerCase().contains(q) || t.category.toLowerCase().contains(q)).toList();

    final matchingHackathons = q.isEmpty
        ? []
        : careerProvider.hackathons.where((h) => h.name.toLowerCase().contains(q) || h.skills.toLowerCase().contains(q)).toList();

    final matchingInternships = q.isEmpty
        ? []
        : careerProvider.internships.where((i) => i.role.toLowerCase().contains(q) || i.company.toLowerCase().contains(q)).toList();

    final totalResults = matchingAssignments.length +
        matchingNotes.length +
        matchingTasks.length +
        matchingHackathons.length +
        matchingInternships.length;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 14, color: colors.primaryText),
          decoration: InputDecoration(
            hintText: 'Search subjects, assignments, notes, jobs, skills...',
            hintStyle: TextStyle(color: colors.secondaryText),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: colors.secondaryText),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: SafeArea(
        child: _query.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, size: 54, color: colors.mutedText),
                    const SizedBox(height: 12),
                    Text(
                      'Global ATTENT-IN Search',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search across assignments, notes, timetable, jobs, and hackathons.',
                      style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                    ),
                  ],
                ),
              )
            : totalResults == 0
                ? const AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No Matching Results',
                    description: 'Try searching with another keyword or subject code.',
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    children: [
                      // Assignments
                      if (matchingAssignments.isNotEmpty) ...[
                        SectionHeader(title: 'Assignments (${matchingAssignments.length})', icon: Icons.assignment_outlined),
                        ...matchingAssignments.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => context.push('/assignments'),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.assignment, color: colors.primary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(a.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: colors.primaryText)),
                                      Text(a.subjectName, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                                    ],
                                  ),
                                ),
                                Text(a.status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primary)),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      // Notes
                      if (matchingNotes.isNotEmpty) ...[
                        SectionHeader(title: 'Notes & Notebook (${matchingNotes.length})', icon: Icons.note_alt_outlined),
                        ...matchingNotes.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => context.push('/notes'),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.edit_note, color: colors.secondary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(n.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: colors.primaryText)),
                                      Text(n.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      // Tasks
                      if (matchingTasks.isNotEmpty) ...[
                        SectionHeader(title: 'Tasks (${matchingTasks.length})', icon: Icons.check_circle_outline),
                        ...matchingTasks.map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => context.push('/tasks'),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(t.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: colors.accent, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: colors.primaryText)),
                                      Text(t.category, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      // Hackathons
                      if (matchingHackathons.isNotEmpty) ...[
                        SectionHeader(title: 'Hackathons (${matchingHackathons.length})', icon: Icons.emoji_events_outlined),
                        ...matchingHackathons.map((h) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => context.push('/hackathons'),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.emoji_events, color: colors.warning, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(h.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: colors.primaryText)),
                                      Text('${h.organizer} • ${h.prize}', style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      // Internships
                      if (matchingInternships.isNotEmpty) ...[
                        SectionHeader(title: 'Internships (${matchingInternships.length})', icon: Icons.work_outline),
                        ...matchingInternships.map((i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => context.push('/internships'),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.work, color: colors.success, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(i.role, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: colors.primaryText)),
                                      Text('${i.company} • ${i.stipend}', style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
      ),
    );
  }
}
