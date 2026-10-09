import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/career_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CareerProvider>().fetchAllCareerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<CareerProvider>();

    final score = provider.overview?.score ?? 72;
    final breakdown = provider.overview?.breakdown ?? {
      'skills': 85,
      'projects': 75,
      'resume': 88,
      'courses': 80,
      'hackathons': 65,
      'internships': 60,
      'mockInterviews': 85,
    };

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Career & Growth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Resume Builder',
            onPressed: () => context.push('/resume'),
          ),
          IconButton(
            icon: const Icon(Icons.record_voice_over_outlined),
            tooltip: 'Mock Interview',
            onPressed: () => context.push('/mock-interview'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchAllCareerData(),
          child: provider.isLoading && provider.overview == null
              ? const AppLoading(message: 'Analyzing career telemetry...')
              : provider.error != null && provider.overview == null
                  ? AppError(message: provider.error!, onRetry: () => provider.fetchAllCareerData())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      children: [
                        // Career Readiness Score Main Banner
                        AppCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Career Readiness Score',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colors.secondaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '$score',
                                            style: GoogleFonts.outfit(
                                              fontSize: 38,
                                              fontWeight: FontWeight.w800,
                                              color: colors.success,
                                            ),
                                          ),
                                          Text(
                                            ' / 100',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: colors.mutedText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: colors.success.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'JOB READY',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: colors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Telemetry Breakdown',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primaryText),
                              ),
                              const SizedBox(height: 8),
                              _buildReadinessBar('Technical Skills', breakdown['skills'] ?? 80, colors.primary, colors),
                              _buildReadinessBar('Projects & Portfolios', breakdown['projects'] ?? 75, colors.secondary, colors),
                              _buildReadinessBar('ATS Resume Strength', breakdown['resume'] ?? 88, colors.accent, colors),
                              _buildReadinessBar('Course Certifications', breakdown['courses'] ?? 80, colors.warning, colors),
                              _buildReadinessBar('Mock Interview Mastery', breakdown['mockInterviews'] ?? 85, colors.success, colors),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Quick Navigation Grid
                        const SectionHeader(title: 'Career Exploration Hub', icon: Icons.explore_outlined),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.5,
                          children: [
                            _buildQuickActionCard(context, 'Hackathons', '${provider.hackathons.length} Open', Icons.emoji_events_outlined, colors.warning, '/hackathons', colors),
                            _buildQuickActionCard(context, 'Internships', '${provider.internships.length} Active', Icons.work_outline, colors.success, '/internships', colors),
                            _buildQuickActionCard(context, 'Full-time Jobs', '${provider.jobs.length} Listed', Icons.business_center_outlined, colors.primary, '/jobs', colors),
                            _buildQuickActionCard(context, 'Certifications', '${provider.courses.length} Courses', Icons.play_lesson_outlined, colors.secondary, '/courses', colors),
                            _buildQuickActionCard(context, 'Skills Matrix', '8 Logged', Icons.star_outline_rounded, colors.accent, '/skills', colors),
                            _buildQuickActionCard(context, 'Resume Builder', 'PDF Ready', Icons.description_outlined, colors.info, '/resume', colors),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Featured Hackathon
                        if (provider.hackathons.isNotEmpty) ...[
                          SectionHeader(
                            title: 'Featured Hackathons',
                            icon: Icons.flash_on_rounded,
                            actionText: 'View All',
                            onActionTap: () => context.push('/hackathons'),
                          ),
                          OpportunityCard(
                            title: provider.hackathons.first.name,
                            subtitle: provider.hackathons.first.organizer,
                            tag: provider.hackathons.first.mode,
                            highlight: provider.hackathons.first.prize,
                            skills: provider.hackathons.first.skillList,
                            description: provider.hackathons.first.description,
                            primaryButtonText: 'Register Now',
                            onPrimaryAction: () => context.push('/hackathons'),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Featured Internship
                        if (provider.internships.isNotEmpty) ...[
                          SectionHeader(
                            title: 'Trending Internships',
                            icon: Icons.trending_up_rounded,
                            actionText: 'View All',
                            onActionTap: () => context.push('/internships'),
                          ),
                          OpportunityCard(
                            title: provider.internships.first.role,
                            subtitle: '${provider.internships.first.company} • ${provider.internships.first.location}',
                            tag: provider.internships.first.mode,
                            highlight: provider.internships.first.stipend,
                            skills: provider.internships.first.skillList,
                            description: provider.internships.first.description,
                            primaryButtonText: 'Apply Direct',
                            onPrimaryAction: () => context.push('/internships'),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildReadinessBar(String title, int value, Color color, AppColorPalette colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.secondaryText,
                ),
              ),
              Text(
                '$value%',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100.0,
              minHeight: 6,
              backgroundColor: colors.elevatedCard,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String route, AppColorPalette colors) {
    return AppCard(
      onTap: () => context.push(route),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryText,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
