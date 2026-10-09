import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/interview.dart';
import '../../services/interview_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/section_header.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  final List<String> _roles = [
    'Flutter Developer',
    'AI/ML Engineer',
    'Software Developer',
    'Data Scientist',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
  ];

  String _selectedRole = 'Flutter Developer';
  String _selectedDifficulty = 'Medium';
  String _selectedType = 'Technical';

  bool _isSessionActive = false;
  bool _isLoading = false;
  Interview? _activeInterview;
  int _currentQuestionIndex = 0;
  final Map<String, TextEditingController> _answerControllers = {};

  List<Interview> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void dispose() {
    _answerControllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    final res = await InterviewService.getHistory();
    if (res.success && res.data != null && mounted) {
      setState(() => _history = res.data!);
    }
  }

  Future<void> _startInterview() async {
    setState(() => _isLoading = true);

    final res = await InterviewService.startInterview(
      role: _selectedRole,
      difficulty: _selectedDifficulty,
      type: _selectedType,
    );

    if (res.success && res.data != null && mounted) {
      _answerControllers.clear();
      for (final q in res.data!.questions) {
        _answerControllers[q.id] = TextEditingController();
      }

      setState(() {
        _activeInterview = res.data;
        _isSessionActive = true;
        _currentQuestionIndex = 0;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? 'Failed to start interview'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  Future<void> _submitInterview() async {
    if (_activeInterview == null) return;
    setState(() => _isLoading = true);

    final answers = _activeInterview!.questions.map((q) {
      return {
        'questionId': q.id,
        'userAnswer': _answerControllers[q.id]?.text.trim() ?? '',
      };
    }).toList();

    final res = await InterviewService.submitInterview(
      interviewId: _activeInterview!.id,
      answers: answers,
    );

    if (res.success && res.data != null && mounted) {
      setState(() {
        _activeInterview = res.data;
        _isLoading = false;
      });
      _fetchHistory();
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('AI Mock Interview'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const AppLoading(message: 'Simulating AI interviewer analysis...')
            : _isSessionActive
                ? _buildActiveSessionView(context, colors)
                : _buildSetupAndHistoryView(context, colors),
      ),
    );
  }

  Widget _buildSetupAndHistoryView(BuildContext context, AppColorPalette colors) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Setup Card
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure Interview Simulation',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 14),

              Text('Target Job Role', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.elevatedCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    dropdownColor: colors.card,
                    items: _roles.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r, style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Difficulty', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: colors.elevatedCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDifficulty,
                              isExpanded: true,
                              dropdownColor: colors.card,
                              items: ['Easy', 'Medium', 'Hard'].map((d) {
                                return DropdownMenuItem(value: d, child: Text(d, style: GoogleFonts.inter(fontSize: 12, color: colors.primaryText)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedDifficulty = val);
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
                        Text('Round Type', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: colors.elevatedCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedType,
                              isExpanded: true,
                              dropdownColor: colors.card,
                              items: ['Technical', 'HR', 'Behavioral'].map((t) {
                                return DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.inter(fontSize: 12, color: colors.primaryText)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedType = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              AppButton(
                text: 'Launch Interview Simulation',
                width: double.infinity,
                icon: Icons.play_arrow_rounded,
                onPressed: _startInterview,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recent Simulation History
        const SectionHeader(title: 'Past Mock Interviews', icon: Icons.history_rounded),

        if (_history.isEmpty)
          const AppEmptyState(
            icon: Icons.mic_none_outlined,
            title: 'No Mock Interviews Yet',
            description: 'Start your first simulation to receive performance telemetry and AI feedback.',
          )
        else
          ..._history.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.role,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.difficulty} • ${item.type} • ${item.questions.length} Questions',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.score}%',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: colors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildActiveSessionView(BuildContext context, AppColorPalette colors) {
    if (_activeInterview == null || _activeInterview!.questions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Check if score is evaluated
    if (_activeInterview!.score > 0) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 48, color: colors.success),
                const SizedBox(height: 10),
                Text(
                  'Interview Completed!',
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: colors.primaryText),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_activeInterview!.role} (${_activeInterview!.difficulty})',
                  style: GoogleFonts.inter(fontSize: 13, color: colors.secondaryText),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_activeInterview!.score}%',
                  style: GoogleFonts.outfit(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 16),
                if (_activeInterview!.strengths != null) ...[
                  _buildFeedbackBox('Strengths', _activeInterview!.strengths!, colors.success, colors),
                  const SizedBox(height: 8),
                ],
                if (_activeInterview!.weaknesses != null) ...[
                  _buildFeedbackBox('Areas for Growth', _activeInterview!.weaknesses!, colors.warning, colors),
                  const SizedBox(height: 8),
                ],
                if (_activeInterview!.suggestions != null) ...[
                  _buildFeedbackBox('Next Action Steps', _activeInterview!.suggestions!, colors.primary, colors),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            text: 'Finish & Return to Hub',
            width: double.infinity,
            onPressed: () {
              setState(() {
                _isSessionActive = false;
                _activeInterview = null;
              });
            },
          ),
        ],
      );
    }

    final totalQuestions = _activeInterview!.questions.length;
    final currentQ = _activeInterview!.questions[_currentQuestionIndex];
    final ctrl = _answerControllers[currentQ.id] ?? TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of $totalQuestions',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              Text(
                _activeInterview!.role,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / totalQuestions,
              minHeight: 6,
              backgroundColor: colors.elevatedCard,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          const SizedBox(height: 20),
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Text(
              currentQ.question,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: colors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Technical Response',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            maxLines: 7,
            style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
            decoration: const InputDecoration(
              hintText: 'Type your explanation, algorithm analysis, trade-offs, and architectural structure here...',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (_currentQuestionIndex > 0) ...[
                Expanded(
                  child: AppButton(
                    text: 'Previous',
                    type: AppButtonType.secondary,
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: AppButton(
                  text: _currentQuestionIndex == totalQuestions - 1 ? 'Submit & Evaluate' : 'Next Question',
                  onPressed: () {
                    if (_currentQuestionIndex < totalQuestions - 1) {
                      setState(() => _currentQuestionIndex++);
                    } else {
                      _submitInterview();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackBox(String title, String content, Color color, AppColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.elevatedCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
