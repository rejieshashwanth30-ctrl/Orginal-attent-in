import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_card.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  final List<Map<String, dynamic>> _resourceCategories = const [
    {
      'title': 'Academic Curricula & Syllabus',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF38BDF8),
      'count': '18 Documents',
      'items': ['Computer Science Sem 6 Syllabus PDF', 'Data Structures Reference Guide', 'Compiler Design Lab Manual'],
    },
    {
      'title': 'Previous Year Question Papers',
      'icon': Icons.history_edu_rounded,
      'color': Color(0xFF818CF8),
      'count': '42 Exam Papers',
      'items': ['2025 Midterm Exam Pack', '2024 End Semester Solutions', 'GATE CSE Practice Set'],
    },
    {
      'title': 'E-Books & Research Papers',
      'icon': Icons.library_books_rounded,
      'color': Color(0xFF34D399),
      'count': '24 E-Books',
      'items': ['Introduction to Algorithms (CLRS)', 'Operating System Concepts (Silberschatz)', 'Deep Learning (Goodfellow)'],
    },
    {
      'title': 'Cheatsheets & Quick Formulae',
      'icon': Icons.speed_rounded,
      'color': Color(0xFFFBBF24),
      'count': '15 Sheets',
      'items': ['SQL Query Mastery Guide', 'Git & Linux Commands Cheat Sheet', 'Flutter Architecture Patterns'],
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
          'Academic Resources',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: colors.primaryText),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _resourceCategories.length,
        itemBuilder: (context, index) {
          final cat = _resourceCategories[index];
          final color = cat['color'] as Color;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat['icon'] as IconData, color: color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['title'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryText,
                              ),
                            ),
                            Text(
                              cat['count'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: colors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...(cat['items'] as List<String>).map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.description_outlined, size: 16, color: color.withValues(alpha: 0.8)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: colors.primaryText,
                              ),
                            ),
                          ),
                          Icon(Icons.download_rounded, size: 16, color: colors.mutedText),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
