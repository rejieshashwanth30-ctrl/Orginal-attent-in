import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/course.dart';
import '../../services/career_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/opportunity_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;
  String _selectedLevel = 'ALL';

  final List<String> _levels = ['ALL', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await CareerService.getCourses(level: _selectedLevel);
    if (res.success && res.data != null) {
      setState(() {
        _courses = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load courses';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses & Certifications'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _levels.map((lvl) {
                  final isSelected = _selectedLevel == lvl;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(lvl, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                      selected: isSelected,
                      selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                      onSelected: (_) {
                        setState(() => _selectedLevel = lvl);
                        _fetchCourses();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchCourses,
                child: _isLoading
                    ? const AppLoading(message: 'Curating certified courses...')
                    : _error != null
                        ? AppError(message: _error!, onRetry: _fetchCourses)
                        : _courses.isEmpty
                            ? const AppEmptyState(
                                icon: Icons.play_lesson_outlined,
                                title: 'No Courses Found',
                                description: 'Try switching the level filter.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: _courses.length,
                                itemBuilder: (context, index) {
                                  final course = _courses[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: OpportunityCard(
                                      title: course.name,
                                      subtitle: '${course.provider} • ${course.level}',
                                      tag: '${course.rating} ★',
                                      tagColor: AppColors.warning,
                                      highlight: course.duration,
                                      skills: course.skillList,
                                      description: course.description,
                                      primaryButtonText: 'Start Learning',
                                      onPrimaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Course started! Enrolled in ${course.name}')),
                                        );
                                      },
                                      secondaryButtonText: 'Preview',
                                      onSecondaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Course syllabus preview for ${course.name}')),
                                        );
                                      },
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
