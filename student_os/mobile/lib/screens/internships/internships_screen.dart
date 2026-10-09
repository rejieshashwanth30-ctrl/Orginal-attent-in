import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/internship.dart';
import '../../services/career_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/opportunity_card.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  List<Internship> _internships = [];
  bool _isLoading = true;
  String? _error;
  String _selectedMode = 'ALL';

  final List<String> _modes = ['ALL', 'Remote', 'Hybrid', 'On-site'];

  @override
  void initState() {
    super.initState();
    _fetchInternships();
  }

  Future<void> _fetchInternships() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await CareerService.getInternships(mode: _selectedMode);
    if (res.success && res.data != null) {
      setState(() {
        _internships = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load internships';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Discovery'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _modes.map((mode) {
                  final isSelected = _selectedMode == mode;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(mode, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                      selected: isSelected,
                      selectedColor: AppColors.success.withValues(alpha: 0.2),
                      onSelected: (_) {
                        setState(() => _selectedMode = mode);
                        _fetchInternships();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchInternships,
                child: _isLoading
                    ? const AppLoading(message: 'Curating top internships...')
                    : _error != null
                        ? AppError(message: _error!, onRetry: _fetchInternships)
                        : _internships.isEmpty
                            ? const AppEmptyState(
                                icon: Icons.work_outline,
                                title: 'No Internships Found',
                                description: 'Try adjusting the mode filter.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: _internships.length,
                                itemBuilder: (context, index) {
                                  final intern = _internships[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: OpportunityCard(
                                      title: intern.role,
                                      subtitle: '${intern.company} • ${intern.location}',
                                      tag: intern.mode,
                                      tagColor: AppColors.success,
                                      highlight: intern.stipend,
                                      skills: intern.skillList,
                                      description: '${intern.description}\nDuration: ${intern.duration}',
                                      primaryButtonText: 'Apply Direct',
                                      onPrimaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Opening direct application for ${intern.company}')),
                                        );
                                      },
                                      secondaryButtonText: 'Save',
                                      onSecondaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Saved to your career wishlist!')),
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
