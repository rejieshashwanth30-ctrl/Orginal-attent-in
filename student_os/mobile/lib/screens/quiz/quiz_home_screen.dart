import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note.dart';
import '../../models/subject.dart';
import '../../providers/note_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/premium/premium_upgrade_dialog.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  String _selectedSemester = 'Semester 6';
  Subject? _selectedSubject;
  String _selectedTopic = 'Unit 2';
  String _selectedDifficulty = 'Medium';
  int _selectedQuestionCount = 10;
  String _selectedQuestionType = 'MCQ';
  bool _isAdaptive = false;
  Note? _selectedNote;

  final TextEditingController _customSubjectCtrl = TextEditingController();
  final TextEditingController _customTopicCtrl = TextEditingController();

  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

  final List<String> _topics = [
    'Entire Subject',
    'Unit 1',
    'Unit 2',
    'Unit 3',
    'Unit 4',
    'Unit 5',
    'Specific Topic',
    'Uploaded Notes',
  ];

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Mixed'];
  final List<int> _questionCounts = [5, 10, 15, 20, 30];
  final List<String> _questionTypes = ['MCQ', 'True / False', 'Multiple Select', 'Mixed'];

  @override
  void initState() {
    super.initState();
    if (MockDataService.subjects.isNotEmpty) {
      _selectedSubject = MockDataService.subjects.first;
    }
  }

  @override
  void dispose() {
    _customSubjectCtrl.dispose();
    _customTopicCtrl.dispose();
    super.dispose();
  }

  void _generateQuiz() async {
    if (_selectedSubject == null && _customSubjectCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a subject')),
      );
      return;
    }

    final sub = _selectedSubject ??
        Subject(
          id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
          userId: MockDataService.currentUser.id,
          name: _customSubjectCtrl.text.trim(),
          code: 'GEN101',
        );

    final topic = _selectedTopic == 'Specific Topic'
        ? (_customTopicCtrl.text.trim().isNotEmpty ? _customTopicCtrl.text.trim() : 'Core Concepts')
        : (_selectedTopic == 'Uploaded Notes' ? (_selectedNote?.title ?? 'Uploaded Notes') : _selectedTopic);

    final quizProvider = context.read<QuizProvider>();
    final success = await quizProvider.generateQuiz(
      semester: _selectedSemester,
      subject: sub,
      topic: topic,
      difficulty: _selectedDifficulty,
      questionCount: _selectedQuestionCount,
      questionType: _selectedQuestionType,
      isAdaptive: _isAdaptive,
      sourceNote: _selectedTopic == 'Uploaded Notes' ? _selectedNote : null,
    );

    if (success && mounted) {
      context.push('/quiz/play');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final subProvider = context.watch<SubscriptionProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('AI Quiz Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.workspace_premium_outlined, color: colors.primary),
            tooltip: 'Subscription Entitlements',
            onPressed: () => context.push('/premium'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border, width: 1),
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.quiz_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI QUIZ GENERATOR',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: colors.primaryText,
                                ),
                              ),
                              Text(
                                'Grounded Diagnostic Assessments',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Generates questions grounded in your active semester subjects, units, and class notes.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: colors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. Select Semester
              Text(
                '1. Select Semester',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primaryText),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _semesters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final sem = _semesters[index];
                    final isSelected = sem == _selectedSemester;
                    return ChoiceChip(
                      label: Text(
                        sem,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : colors.secondaryText,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colors.primary,
                      backgroundColor: colors.card,
                      side: BorderSide(color: isSelected ? colors.primary : colors.border),
                      onSelected: (_) => setState(() => _selectedSemester = sem),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 2. Select Subject
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2. Select Subject',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primaryText),
                  ),
                  Text(
                    'Academic Data',
                    style: GoogleFonts.inter(fontSize: 11, color: colors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    DropdownButtonFormField<Subject>(
                      initialValue: _selectedSubject,
                      isExpanded: true,
                      dropdownColor: colors.card,
                      decoration: InputDecoration(
                        labelText: 'Select Subject',
                        prefixIcon: Icon(Icons.menu_book_outlined, color: colors.primary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: MockDataService.subjects.map((sub) {
                        return DropdownMenuItem(
                          value: sub,
                          child: Text(
                            '${sub.name} (${sub.code})',
                            style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSubject = val),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _customSubjectCtrl,
                      label: 'Or Add Subject Manually',
                      hint: 'e.g. Operating Systems',
                      prefixIcon: Icons.add_circle_outline_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Topic & Scope
              Text(
                '3. Topic / Scope',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primaryText),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _topics.map((t) {
                  final isSelected = t == _selectedTopic;
                  return ChoiceChip(
                    label: Text(
                      t,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : colors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: colors.primary,
                    backgroundColor: colors.card,
                    side: BorderSide(color: isSelected ? colors.primary : colors.border),
                    onSelected: (_) => setState(() => _selectedTopic = t),
                  );
                }).toList(),
              ),

              if (_selectedTopic == 'Specific Topic') ...[
                const SizedBox(height: 10),
                AppTextField(
                  controller: _customTopicCtrl,
                  label: 'Specify Academic Topic',
                  hint: 'e.g. Backpropagation & CNNs',
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],

              if (_selectedTopic == 'Uploaded Notes') ...[
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField<Note>(
                    initialValue: _selectedNote ?? (noteProvider.notes.isNotEmpty ? noteProvider.notes.first : null),
                    isExpanded: true,
                    dropdownColor: colors.card,
                    decoration: InputDecoration(
                      labelText: 'Select Uploaded Note Source',
                      prefixIcon: Icon(Icons.description_outlined, color: colors.primary),
                    ),
                    items: (noteProvider.notes.isNotEmpty ? noteProvider.notes : MockDataService.notes).map((n) {
                      return DropdownMenuItem(
                        value: n,
                        child: Text(n.title, style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedNote = val),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // 4. Difficulty & Question Count
              Row(
                children: [
                  // Difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Difficulty', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedDifficulty,
                          dropdownColor: colors.card,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d, style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                          onChanged: (val) => setState(() => _selectedDifficulty = val ?? 'Medium'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Questions Count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Questions', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedQuestionCount,
                          dropdownColor: colors.card,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          items: _questionCounts.map((c) => DropdownMenuItem(value: c, child: Text('$c Questions', style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                          onChanged: (val) => setState(() => _selectedQuestionCount = val ?? 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Question Type
              Text('Question Type', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedQuestionType,
                dropdownColor: colors.card,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: _questionTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                onChanged: (val) => setState(() => _selectedQuestionType = val ?? 'MCQ'),
              ),

              const SizedBox(height: 16),

              // 5. Adaptive Mode Switch
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Icon(Icons.bolt_outlined, color: colors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Adaptive Quiz Mode',
                                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: colors.primary, width: 0.8),
                                ),
                                child: Text('PLUS', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: colors.primary)),
                              ),
                            ],
                          ),
                          Text(
                            'Dynamic difficulty scaling & weak concept reinforcement.',
                            style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isAdaptive,
                      activeThumbColor: colors.primary,
                      onChanged: (val) {
                        if (val && !subProvider.entitlements.canUseAdaptiveQuiz()) {
                          PremiumUpgradeDialog.show(
                            context,
                            featureName: 'Adaptive Quiz Engine',
                            description: 'Adaptive quiz mode adjusts difficulty in real-time and reinforces weak concepts. Unlock with Plus/Yearly.',
                          );
                          return;
                        }
                        setState(() => _isAdaptive = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Generate Quiz Button
              AppButton(
                text: 'Generate Quiz',
                icon: Icons.quiz_outlined,
                width: double.infinity,
                isLoading: quizProvider.isLoading,
                onPressed: _generateQuiz,
              ),

              const SizedBox(height: 28),

              // Recent Quiz History Section
              if (quizProvider.history.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Quiz Results', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: colors.primaryText)),
                    Text('${quizProvider.history.length} completed', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                  ],
                ),
                const SizedBox(height: 10),
                ...quizProvider.history.take(3).map((res) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.elevatedCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colors.border, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                '${res.percentage.toInt()}%',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  res.subjectName,
                                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                                ),
                                Text(
                                  'Score: ${res.score}/${res.totalQuestions} • ${res.topic}',
                                  style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 12, color: colors.mutedText),
                        ],
                      ),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
