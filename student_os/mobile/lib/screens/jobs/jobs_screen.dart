import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/job.dart';
import '../../services/career_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/opportunity_card.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<Job> _jobs = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await CareerService.getJobs(search: search);
    if (res.success && res.data != null) {
      setState(() {
        _jobs = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load jobs';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Placement & Jobs'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onSubmitted: (val) => _fetchJobs(search: val),
                decoration: InputDecoration(
                  hintText: 'Search company, role, or skill...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    onPressed: () => _fetchJobs(search: _searchController.text.trim()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchJobs(),
                child: _isLoading
                    ? const AppLoading(message: 'Loading high-growth job opportunities...')
                    : _error != null
                        ? AppError(message: _error!, onRetry: () => _fetchJobs())
                        : _jobs.isEmpty
                            ? const AppEmptyState(
                                icon: Icons.business_center_outlined,
                                title: 'No Jobs Found',
                                description: 'Try searching with a different keyword.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: _jobs.length,
                                itemBuilder: (context, index) {
                                  final job = _jobs[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: OpportunityCard(
                                      title: job.position,
                                      subtitle: '${job.company} • ${job.location}',
                                      tag: job.experience,
                                      tagColor: AppColors.primaryLight,
                                      highlight: job.salary,
                                      skills: job.skillList,
                                      description: job.description,
                                      primaryButtonText: 'Apply on Portal',
                                      onPrimaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Redirecting to career portal for ${job.company}')),
                                        );
                                      },
                                      secondaryButtonText: 'Save Job',
                                      onSecondaryAction: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Job saved to your profile!')),
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
