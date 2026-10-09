import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/note_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import 'notes_copilot_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNoteEditor(BuildContext context, {Note? noteToEdit}) {
    final colors = AppColors.of(context);
    final titleCtrl = TextEditingController(text: noteToEdit?.title ?? '');
    final contentCtrl = TextEditingController(text: noteToEdit?.content ?? '');
    final tagsCtrl = TextEditingController(text: noteToEdit?.tags ?? '');
    bool isPinned = noteToEdit?.isPinned ?? false;

    AppBottomSheet.show(
      context,
      title: noteToEdit == null ? 'Create Class Note' : 'Edit Note',
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            children: [
              AppTextField(
                controller: titleCtrl,
                label: 'Note Title',
                hint: 'e.g. Transformer Attention Formulas',
                prefixIcon: Icons.title_rounded,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: tagsCtrl,
                label: 'Tags (comma separated)',
                hint: 'ML, DeepLearning, Exam',
                prefixIcon: Icons.tag_rounded,
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content (Markdown supported)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: contentCtrl,
                    maxLines: 6,
                    style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                    decoration: const InputDecoration(
                      hintText: 'Type your study notes, definitions, formulas, or code snippets here...',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: isPinned,
                    activeColor: colors.primary,
                    checkColor: Colors.white,
                    onChanged: (val) => setSheetState(() => isPinned = val ?? false),
                  ),
                  Text(
                    'Pin to top of notebook',
                    style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppButton(
                text: noteToEdit == null ? 'Save Note' : 'Update Note',
                width: double.infinity,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty || contentCtrl.text.trim().isEmpty) return;
                  Navigator.of(ctx).pop();

                  final provider = context.read<NoteProvider>();
                  await provider.createNote(
                    title: titleCtrl.text.trim(),
                    content: contentCtrl.text.trim(),
                    tags: tagsCtrl.text.trim(),
                    isPinned: isPinned,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Notes & Notebook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'New Note',
            onPressed: () => _openNoteEditor(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => provider.setSearchQuery(val),
                style: GoogleFonts.inter(fontSize: 13.5, color: colors.primaryText),
                decoration: InputDecoration(
                  hintText: 'Search title, content, or #tags...',
                  prefixIcon: Icon(Icons.search, size: 20, color: colors.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18, color: colors.secondaryText),
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                color: colors.primary,
                backgroundColor: colors.card,
                onRefresh: () => provider.fetchNotes(),
                child: provider.isLoading && provider.notes.isEmpty
                    ? const AppLoading(message: 'Loading notebook...')
                    : provider.error != null && provider.notes.isEmpty
                        ? AppError(message: provider.error!, onRetry: () => provider.fetchNotes())
                        : provider.filteredNotes.isEmpty
                            ? AppEmptyState(
                                icon: Icons.edit_note_outlined,
                                title: 'No Notes Found',
                                description: 'Capture lectures, formulas, and revision insights.',
                                actionText: '+ Create First Note',
                                onAction: () => _openNoteEditor(context),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: provider.filteredNotes.length,
                                itemBuilder: (context, index) {
                                  final note = provider.filteredNotes[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AppCard(
                                      onTap: () => _openNoteEditor(context, noteToEdit: note),
                                      padding: const EdgeInsets.all(16),
                                      border: note.isPinned
                                          ? BorderSide(color: colors.primary.withValues(alpha: 0.6), width: 1.5)
                                          : null,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    if (note.isPinned) ...[
                                                      Icon(Icons.push_pin, size: 15, color: colors.primary),
                                                      const SizedBox(width: 6),
                                                    ],
                                                    Expanded(
                                                      child: Text(
                                                        note.title,
                                                        style: GoogleFonts.outfit(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: colors.primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                                      size: 18,
                                                      color: note.isPinned ? colors.primary : colors.mutedText,
                                                    ),
                                                    onPressed: () => provider.togglePin(note.id),
                                                    constraints: const BoxConstraints(),
                                                    padding: const EdgeInsets.all(6),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete_outline, size: 18),
                                                    color: colors.mutedText,
                                                    onPressed: () => provider.deleteNote(note.id),
                                                    constraints: const BoxConstraints(),
                                                    padding: const EdgeInsets.all(6),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            note.content,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              height: 1.4,
                                              color: colors.secondaryText,
                                            ),
                                          ),
                                          if (note.tagList.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 6,
                                              runSpacing: 4,
                                              children: note.tagList.map((tag) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: colors.elevatedCard,
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: colors.border, width: 0.8),
                                                  ),
                                                  child: Text(
                                                    '#$tag',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: colors.primary,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                          const SizedBox(height: 12),
                                          Wrap(
                                            alignment: WrapAlignment.spaceBetween,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              Text(
                                                'Updated ${DateFormat('MMM d, h:mm a').format(note.updatedAt)}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: colors.mutedText,
                                                ),
                                              ),
                                              Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: [
                                                  // 1. Ask Copilot
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (_) => NotesCopilotScreen(note: note),
                                                        ),
                                                      );
                                                    },
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: colors.primary.withValues(alpha: 0.12),
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 1),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.smart_toy_outlined, size: 12, color: colors.primary),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            'Copilot',
                                                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: colors.primary),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  // 2. Generate Quiz
                                                  InkWell(
                                                    onTap: () async {
                                                      if (note.content.trim().isEmpty) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Note contains no text to generate a quiz from.')),
                                                        );
                                                        return;
                                                      }
                                                      final sub = MockDataService.subjects.first;
                                                      final quizProvider = context.read<QuizProvider>();
                                                      final success = await quizProvider.generateQuiz(
                                                        semester: 'Semester 6',
                                                        subject: sub,
                                                        topic: note.title,
                                                        difficulty: 'Medium',
                                                        questionCount: 5,
                                                        questionType: 'MCQ',
                                                        sourceNote: note,
                                                      );
                                                      if (success && context.mounted) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Quiz generated from: ${note.title}')),
                                                        );
                                                        context.push('/quiz/play');
                                                      }
                                                    },
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: colors.card,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: colors.border, width: 1),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.quiz_outlined, size: 12, color: colors.secondaryText),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            'Quiz',
                                                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: colors.secondaryText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  // 3. Create Flashcards
                                                  InkWell(
                                                    onTap: () async {
                                                      if (note.content.trim().isEmpty) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Note contains no text to generate flashcards from.')),
                                                        );
                                                        return;
                                                      }
                                                      final sub = MockDataService.subjects.first;
                                                      final flashProvider = context.read<FlashcardProvider>();
                                                      final set = await flashProvider.generateFlashcards(
                                                        subject: sub,
                                                        unit: 'Unit Notes',
                                                        topic: note.title,
                                                        cardCount: 5,
                                                        difficulty: 'Medium',
                                                        sourceNote: note,
                                                      );
                                                      if (set != null && context.mounted) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Created flashcards for: ${note.title}')),
                                                        );
                                                        context.push('/flashcards/study');
                                                      }
                                                    },
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: colors.card,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: colors.border, width: 1),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.style_outlined, size: 12, color: colors.secondaryText),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            'Cards',
                                                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: colors.secondaryText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
