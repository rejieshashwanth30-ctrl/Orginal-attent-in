import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hackathon.dart';
import '../../services/career_service.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/opportunity_card.dart';

class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen> {
  List<Hackathon> _hackathons = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'ALL';

  final List<String> _categories = ['ALL', 'AI', 'Web', 'Mobile', 'Blockchain', 'IoT', 'Cybersecurity'];

  @override
  void initState() {
    super.initState();
    _fetchHackathons();
  }

  Future<void> _fetchHackathons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await CareerService.getHackathons(category: _selectedCategory);
    if (res.success && res.data != null) {
      setState(() {
        _hackathons = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load hackathons';
        _isLoading = false;
      });
    }
  }

  void _showDetails(Hackathon h) {
    AppDialog.show(
      context,
      title: h.name,
      content: 'Organizer: ${h.organizer}\n'
          'Dates: ${h.date}\n'
          'Mode: ${h.mode}\n'
          'Prize: ${h.prize}\n'
          'Skills: ${h.skills}\n\n'
          'Overview:\n${h.description}',
      confirmText: 'Register Now',
      cancelText: 'Close',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackathon Discovery'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                      selected: isSelected,
                      selectedColor: AppColors.warning.withValues(alpha: 0.2),
                      onSelected: (_) {
                        setState(() => _selectedCategory = cat);
                        _fetchHackathons();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchHackathons,
                child: _isLoading
                    ? const AppLoading(message: 'Searching hackathons...')
                    : _error != null
                        ? AppError(message: _error!, onRetry: _fetchHackathons)
                        : _hackathons.isEmpty
                            ? const AppEmptyState(
                                icon: Icons.emoji_events_outlined,
                                title: 'No Hackathons Found',
                                description: 'Try switching the category filter.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: _hackathons.length,
                                itemBuilder: (context, index) {
                                  final h = _hackathons[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: OpportunityCard(
                                      title: h.name,
                                      subtitle: '${h.organizer} • ${h.date}',
                                      tag: h.mode,
                                      tagColor: AppColors.warning,
                                      highlight: h.prize,
                                      skills: h.skillList,
                                      description: h.description,
                                      primaryButtonText: 'Register',
                                      onPrimaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Registration portal opened for ${h.name}')),
                                        );
                                      },
                                      secondaryButtonText: 'Details',
                                      onSecondaryAction: () => _showDetails(h),
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
