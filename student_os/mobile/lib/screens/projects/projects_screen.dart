import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final List<Map<String, dynamic>> _projects = [
    {
      'id': 'proj-1',
      'title': 'ATTENT-IN Smart Student Platform',
      'category': 'Mobile & AI',
      'description': 'An intelligent all-in-one student life and academic operating system with real-time analytics.',
      'techStack': ['Flutter', 'Dart', 'Provider', 'Gemini AI'],
      'progress': 0.85,
      'status': 'Active',
      'github': 'github.com/student/student-os',
    },
    {
      'id': 'proj-2',
      'title': 'Autonomous Rover Telemetry',
      'category': 'Robotics & IoT',
      'description': 'Low-latency telemetry streaming dashboard for university competition robotics rover.',
      'techStack': ['Python', 'ROS2', 'WebSockets', 'C++'],
      'progress': 0.60,
      'status': 'In Progress',
      'github': 'github.com/student/rover-telemetry',
    },
    {
      'id': 'proj-3',
      'title': 'Distributed Key-Value Store',
      'category': 'Systems Engineering',
      'description': 'Fault-tolerant distributed storage node implementation with Raft consensus protocol.',
      'techStack': ['Go', 'gRPC', 'Docker', 'Raft'],
      'progress': 1.0,
      'status': 'Completed',
      'github': 'github.com/student/distributed-kv',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Student Projects',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: colors.primaryText),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: colors.primary),
            onPressed: () => _showAddProjectDialog(context, colors),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final p = _projects[index];
          final progress = p['progress'] as double;
          final isDone = progress >= 1.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          p['category'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDone ? colors.success : colors.warning).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          p['status'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDone ? colors.success : colors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p['title'],
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p['description'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (p['techStack'] as List<String>).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.border, width: 0.8),
                        ),
                        child: Text(
                          tech,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colors.primaryText,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: colors.elevatedCard,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDone ? colors.success : colors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context, AppColorPalette colors) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        title: Text('Add New Project', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: colors.primaryText)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: TextStyle(color: colors.primaryText),
              decoration: const InputDecoration(labelText: 'Project Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryCtrl,
              style: TextStyle(color: colors.primaryText),
              decoration: const InputDecoration(labelText: 'Category (e.g. AI, Web, Mobile)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 2,
              style: TextStyle(color: colors.primaryText),
              decoration: const InputDecoration(labelText: 'Short Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: colors.secondaryText)),
          ),
          AppButton(
            text: 'Save Project',
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _projects.insert(0, {
                    'id': 'proj-${DateTime.now().millisecondsSinceEpoch}',
                    'title': titleCtrl.text.trim(),
                    'category': categoryCtrl.text.trim().isNotEmpty ? categoryCtrl.text.trim() : 'Software',
                    'description': descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'Independent engineering project.',
                    'techStack': ['Flutter', 'Dart'],
                    'progress': 0.1,
                    'status': 'Active',
                    'github': 'github.com/student',
                  });
                });
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}
