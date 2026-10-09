import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_card.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _academics = [
    {'title': 'Attendance', 'route': '/attendance', 'icon': Icons.calendar_today_outlined, 'desc': 'Subject metrics & 75% calculator', 'badge': null},
    {'title': 'Timetable', 'route': '/timetable', 'icon': Icons.schedule_outlined, 'desc': 'Weekly class & lab schedule', 'badge': null},
    {'title': 'Notes & Notebook', 'route': '/notes', 'icon': Icons.edit_note_outlined, 'desc': 'Class notes, tags & PDF search', 'badge': null},
    {'title': 'Assignments', 'route': '/assignments', 'icon': Icons.assignment_outlined, 'desc': 'Submissions, priorities & deadlines', 'badge': null},
    {'title': 'Study Plan', 'route': '/study-planner', 'icon': Icons.auto_graph_outlined, 'desc': 'Intelligent session scheduler', 'badge': null},
    {'title': 'CGPA Calculator', 'route': '/cgpa', 'icon': Icons.calculate_outlined, 'desc': 'GPA formula & target solver', 'badge': null},
    {'title': 'AI Quiz', 'route': '/quiz', 'icon': Icons.quiz_outlined, 'desc': 'Syllabus & notes practice tests', 'badge': 'PRO'},
    {'title': 'AI Flashcards', 'route': '/flashcards', 'icon': Icons.style_outlined, 'desc': 'Active recall & flip decks', 'badge': 'PRO'},
    {'title': 'Exam Manager', 'route': '/exams', 'icon': Icons.alarm_on_outlined, 'desc': 'Countdowns & syllabus breakdown', 'badge': null},
    {'title': 'Academic Calendar', 'route': '/calendar', 'icon': Icons.calendar_month_outlined, 'desc': 'Events, exams & deadlines', 'badge': null},
    {'title': 'Course Catalog', 'route': '/courses', 'icon': Icons.play_lesson_outlined, 'desc': 'Skill certifications & courses', 'badge': null},
  ];

  final List<Map<String, dynamic>> _campus = [
    {'title': 'Canteen', 'route': '/canteen', 'icon': Icons.restaurant_rounded, 'desc': 'Pre-order food & skip break queues', 'badge': 'NEW'},
    {'title': 'Hostel Management', 'route': '/hostel', 'icon': Icons.apartment_outlined, 'desc': 'Room, mess, leave & complaints', 'badge': null},
    {'title': 'Library Management', 'route': '/library', 'icon': Icons.local_library_outlined, 'desc': 'Books catalog, dues & digital e-books', 'badge': null},
    {'title': 'Clubs & Societies', 'route': '/clubs', 'icon': Icons.groups_outlined, 'desc': 'Societies, hackathons & events', 'badge': null},
    {'title': 'Campus Transport', 'route': '/transport', 'icon': Icons.directions_bus_outlined, 'desc': 'Shuttle bus live routes & timings', 'badge': null},
    {'title': 'Student Achievements', 'route': '/achievements', 'icon': Icons.emoji_events_outlined, 'desc': 'Badges, XP & streak rewards', 'badge': null},
    {'title': 'Academic Resources', 'route': '/resources', 'icon': Icons.library_books_outlined, 'desc': 'PYQs, question banks & guides', 'badge': null},
  ];

  final List<Map<String, dynamic>> _career = [
    {'title': 'Hackathons Discovery', 'route': '/hackathons', 'icon': Icons.emoji_events_outlined, 'desc': 'Global competitions & prizes', 'badge': null},
    {'title': 'Internships Portal', 'route': '/internships', 'icon': Icons.work_outline_rounded, 'desc': 'Summer & full-term openings', 'badge': null},
    {'title': 'Placement Jobs', 'route': '/jobs', 'icon': Icons.business_center_outlined, 'desc': 'Graduate roles & compensation', 'badge': null},
    {'title': 'Resume Builder', 'route': '/resume', 'icon': Icons.description_outlined, 'desc': 'Live ATS editor & PDF export', 'badge': null},
    {'title': 'Skill Matrix', 'route': '/skills', 'icon': Icons.star_border_rounded, 'desc': 'Technical & soft proficiency', 'badge': null},
    {'title': 'Mock Interview', 'route': '/mock-interview', 'icon': Icons.record_voice_over_outlined, 'desc': 'Interactive AI role simulations', 'badge': 'PRO'},
    {'title': 'Projects Tracker', 'route': '/projects', 'icon': Icons.folder_outlined, 'desc': 'Milestone tracking & GitHub sync', 'badge': null},
  ];

  final List<Map<String, dynamic>> _aiTools = [
    {'title': 'AI Tutor Copilot', 'route': '/ai-assistant', 'icon': Icons.smart_toy_outlined, 'desc': 'Instant academic doubt clearance', 'badge': 'AI'},
    {'title': 'AI Quiz Generator', 'route': '/quiz', 'icon': Icons.auto_awesome_outlined, 'desc': 'Adaptive tests from syllabus', 'badge': 'AI'},
    {'title': 'Notes Copilot', 'route': '/notes', 'icon': Icons.edit_note_rounded, 'desc': 'Grounded note synthesis & Q&A', 'badge': 'AI'},
    {'title': 'AI Flashcard Maker', 'route': '/flashcards', 'icon': Icons.style_outlined, 'desc': 'Spaced repetition from notes', 'badge': 'AI'},
    {'title': 'AI Study Coach', 'route': '/study-planner', 'icon': Icons.model_training_outlined, 'desc': 'Adaptive schedule solver', 'badge': 'AI'},
    {'title': 'CGPA AI Predictor', 'route': '/cgpa', 'icon': Icons.query_stats_outlined, 'desc': 'Target GPA simulator & forecasts', 'badge': 'AI'},
    {'title': 'Transport AI Assistant', 'route': '/transport', 'icon': Icons.assistant_direction_outlined, 'desc': 'Natural language shuttle answers', 'badge': 'AI'},
    {'title': 'ATTENT-IN Premium', 'route': '/premium', 'icon': Icons.workspace_premium_outlined, 'desc': 'Pro & Plus subscription tiers', 'badge': 'PLUS'},
    {'title': 'System Settings', 'route': '/settings', 'icon': Icons.settings_outlined, 'desc': 'Theme, API host & preferences', 'badge': null},
    {'title': 'Notifications', 'route': '/notifications', 'icon': Icons.notifications_outlined, 'desc': 'Alerts, deadlines & reminders', 'badge': null},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getAllFeatures() {
    final Map<String, Map<String, dynamic>> unique = {};
    for (var item in [..._academics, ..._campus, ..._career, ..._aiTools]) {
      unique[item['title'] as String] = item;
    }
    return unique.values.toList();
  }

  List<Map<String, dynamic>> _filterFeatures() {
    if (_searchQuery.trim().isEmpty) return [];
    final q = _searchQuery.toLowerCase().trim();
    return _getAllFeatures().where((f) {
      final title = (f['title'] as String).toLowerCase();
      final desc = (f['desc'] as String).toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isSearching = _searchQuery.trim().isNotEmpty;
    final searchResults = _filterFeatures();

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final safeBottom = bottomInset > 0 ? bottomInset + 8.0 : 16.0;
    final contentBottomPadding = safeBottom + 68.0 + 20.0;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Explore Features',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colors.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: contentBottomPadding),
              children: [
                // 1. Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSearching ? colors.primary : colors.border,
                      width: isSearching ? 1.2 : 1,
                    ),
                    boxShadow: [
                      colors.cardShadow,
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.inter(fontSize: 13.5, color: colors.primaryText),
                    decoration: InputDecoration(
                      hintText: 'Search features (e.g. Library, Hostel, Quiz, Transport)...',
                      hintStyle: GoogleFonts.inter(color: colors.mutedText, fontSize: 13),
                      prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.primary),
                      suffixIcon: isSearching
                          ? IconButton(
                              icon: Icon(Icons.close_rounded, size: 18, color: colors.mutedText),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Search Results View
                if (isSearching) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SEARCH RESULTS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: colors.primaryText,
                        ),
                      ),
                      Text(
                        '${searchResults.length} found',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (searchResults.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.border, width: 1),
                        boxShadow: [colors.cardShadow],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 36, color: colors.mutedText),
                            const SizedBox(height: 8),
                            Text(
                              'No features matching "$_searchQuery"',
                              style: GoogleFonts.inter(fontSize: 13, color: colors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    _buildFeatureGrid(searchResults),
                ] else ...[
                  // 3. Categorized Sections

                  // Section 1: ACADEMICS
                  _buildCategoryHeader('ACADEMICS', Icons.school_rounded, [colors.primary, colors.primaryLight]),
                  const SizedBox(height: 12),
                  _buildFeatureGrid(_academics),
                  const SizedBox(height: 24),

                  // Section 2: CAMPUS
                  _buildCategoryHeader('CAMPUS', Icons.apartment_rounded, [colors.success, colors.accentCyan]),
                  const SizedBox(height: 12),
                  _buildFeatureGrid(_campus),
                  const SizedBox(height: 24),

                  // Section 3: CAREER
                  _buildCategoryHeader('CAREER', Icons.work_rounded, [colors.warning, colors.danger]),
                  const SizedBox(height: 12),
                  _buildFeatureGrid(_career),
                  const SizedBox(height: 24),

                  // Section 4: AI TOOLS
                  _buildCategoryHeader('AI TOOLS', Icons.auto_awesome_rounded, [const Color(0xFF8B5CF6), colors.primary]),
                  const SizedBox(height: 12),
                  _buildFeatureGrid(_aiTools),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon, List<Color> gradient) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(colors: gradient),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: colors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(List<Map<String, dynamic>> items) {
    final colors = AppColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 840) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 500) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 124,
          ),
          itemBuilder: (context, index) {
            final m = items[index];
            final badge = m['badge'] as String?;

            return AppCard(
              onTap: () => context.push(m['route'] as String),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border, width: 0.8),
                        ),
                        child: Icon(m['icon'] as IconData, size: 16, color: colors.primary),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: colors.subtleAccentBg,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: colors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: colors.mutedText,
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m['desc'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          height: 1.25,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
