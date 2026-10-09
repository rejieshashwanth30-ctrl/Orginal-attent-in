import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note.dart';
import '../../models/subject.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/note_provider.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class FlashcardsGenerateScreen extends StatefulWidget {
  const FlashcardsGenerateScreen({super.key});

  @override
  State<FlashcardsGenerateScreen> createState() => _FlashcardsGenerateScreenState();
}

class _FlashcardsGenerateScreenState extends State<FlashcardsGenerateScreen> {
  Subject? _selectedSubject;
  String _selectedUnit = 'Unit 2';
  final TextEditingController _topicCtrl = TextEditingController(text: 'Classification & Neural Nets');
  int _cardCount = 10;
  String _difficulty = 'Medium';
  bool _useUploadedNote = false;
  Note? _selectedNote;

  final List<String> _units = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4', 'Unit 5', 'Entire Syllabus'];
  final List<int> _cardCounts = [5, 10, 15, 20];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    if (MockDataService.subjects.isNotEmpty) {
      _selectedSubject = MockDataService.subjects.first;
    }
  }

  @override
  void dispose() {
    _topicCtrl.dispose();
    super.dispose();
  }

  void _generate() async {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject')),
      );
      return;
    }

    final provider = context.read<FlashcardProvider>();
    final set = await provider.generateFlashcards(
      subject: _selectedSubject!,
      unit: _selectedUnit,
      topic: _useUploadedNote && _selectedNote != null ? _selectedNote!.title : _topicCtrl.text.trim(),
      cardCount: _cardCount,
      difficulty: _difficulty,
      sourceNote: _useUploadedNote ? _selectedNote : null,
    );

    if (set != null && mounted) {
      context.pushReplacement('/flashcards/study');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final flashcardProvider = context.watch<FlashcardProvider>();
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Generate Flashcards'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Flashcard Generator',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: colors.primaryText),
              ),
              const SizedBox(height: 4),
              Text(
                'Synthesize high-yield active recall flashcards from syllabus or notes.',
                style: GoogleFonts.inter(fontSize: 12.5, color: colors.secondaryText),
              ),
              const SizedBox(height: 20),

              // Subject Selection
              Text('Subject', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primaryText)),
              const SizedBox(height: 6),
              DropdownButtonFormField<Subject>(
                initialValue: _selectedSubject,
                isExpanded: true,
                dropdownColor: colors.card,
                decoration: InputDecoration(prefixIcon: Icon(Icons.book_outlined, color: colors.primary)),
                items: MockDataService.subjects.map((sub) {
                  return DropdownMenuItem(
                    value: sub,
                    child: Text('${sub.name} (${sub.code})', style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedSubject = val),
              ),

              const SizedBox(height: 16),

              // Uploaded Note Toggle
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: colors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Generate from Uploaded Notes',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
                      ),
                    ),
                    Switch(
                      value: _useUploadedNote,
                      activeThumbColor: colors.primary,
                      onChanged: (val) => setState(() => _useUploadedNote = val),
                    ),
                  ],
                ),
              ),

              if (_useUploadedNote) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<Note>(
                  initialValue: _selectedNote ?? (noteProvider.notes.isNotEmpty ? noteProvider.notes.first : null),
                  isExpanded: true,
                  dropdownColor: colors.card,
                  decoration: InputDecoration(labelText: 'Select Note Document', prefixIcon: Icon(Icons.description_outlined, color: colors.primary)),
                  items: (noteProvider.notes.isNotEmpty ? noteProvider.notes : MockDataService.notes).map((n) {
                    return DropdownMenuItem(value: n, child: Text(n.title, style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedNote = val),
                ),
              ],

              const SizedBox(height: 16),

              // Unit & Topic
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Syllabus Unit', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedUnit,
                          dropdownColor: colors.card,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                          onChanged: (val) => setState(() => _selectedUnit = val ?? 'Unit 1'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cards Count', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _cardCount,
                          dropdownColor: colors.card,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          items: _cardCounts.map((c) => DropdownMenuItem(value: c, child: Text('$c Cards', style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                          onChanged: (val) => setState(() => _cardCount = val ?? 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (!_useUploadedNote) ...[
                AppTextField(
                  controller: _topicCtrl,
                  label: 'Target Topic / Concept',
                  hint: 'e.g. Backpropagation, CNN, Softmax',
                  prefixIcon: Icons.psychology_outlined,
                ),
                const SizedBox(height: 16),
              ],

              // Difficulty
              Text('Difficulty Level', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                dropdownColor: colors.card,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d, style: TextStyle(fontSize: 12, color: colors.primaryText)))).toList(),
                onChanged: (val) => setState(() => _difficulty = val ?? 'Medium'),
              ),

              const SizedBox(height: 28),

              // Submit Button
              AppButton(
                text: 'Generate Flashcards',
                icon: Icons.auto_awesome,
                width: double.infinity,
                isLoading: flashcardProvider.isLoading,
                onPressed: _generate,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
