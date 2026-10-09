import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/notes_copilot_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../services/mock_data_service.dart';

class NotesCopilotScreen extends StatefulWidget {
  final Note note;

  const NotesCopilotScreen({super.key, required this.note});

  @override
  State<NotesCopilotScreen> createState() => _NotesCopilotScreenState();
}

class _NotesCopilotScreenState extends State<NotesCopilotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _quickPrompts = [
    {'label': 'Summarize', 'icon': Icons.summarize_outlined, 'prompt': 'Summarize this chapter and list the core takeaways.'},
    {'label': 'Explain Simply', 'icon': Icons.lightbulb_outline_rounded, 'prompt': 'Explain the central concepts in this note simply like I am a beginner.'},
    {'label': 'Exam Questions', 'icon': Icons.quiz_outlined, 'prompt': 'Generate predicted 2-mark and 16-mark university exam questions from this note.'},
    {'label': 'Create MCQs', 'icon': Icons.checklist_outlined, 'prompt': 'Create 2 interactive MCQs with answers from this note.'},
    {'label': 'Flashcards', 'icon': Icons.style_outlined, 'prompt': 'Make revision flashcards for key terms in this note.'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesCopilotProvider>().setActiveNote(widget.note);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuery(String query) {
    if (query.trim().isEmpty) return;
    _textController.clear();
    context.read<NotesCopilotProvider>().sendMessage(query);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final copilot = context.watch<NotesCopilotProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.smart_toy_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 6),
                Text(
                  'NOTES COPILOT',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
            Text(
              widget.note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz_outlined, size: 20, color: colors.primary),
            tooltip: 'Generate Quiz',
            onPressed: () async {
              final sub = MockDataService.subjects.first;
              final quizProvider = context.read<QuizProvider>();
              final success = await quizProvider.generateQuiz(
                semester: 'Semester 6',
                subject: sub,
                topic: widget.note.title,
                difficulty: 'Medium',
                questionCount: 5,
                questionType: 'MCQ',
                sourceNote: widget.note,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Quiz generated from: ${widget.note.title}')),
                );
                context.push('/quiz/play');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.style_outlined, size: 20, color: colors.primary),
            tooltip: 'Create Flashcards',
            onPressed: () async {
              final sub = MockDataService.subjects.first;
              final flashProvider = context.read<FlashcardProvider>();
              final set = await flashProvider.generateFlashcards(
                subject: sub,
                unit: 'Note Revision',
                topic: widget.note.title,
                cardCount: 5,
                difficulty: 'Medium',
                sourceNote: widget.note,
              );
              if (set != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Created flashcards for: ${widget.note.title}')),
                );
                context.push('/flashcards/study');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, size: 20, color: colors.secondaryText),
            tooltip: 'Clear Chat',
            onPressed: () => copilot.clearChat(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Note Context Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.card,
                border: Border(
                  bottom: BorderSide(color: colors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, size: 14, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Context: ${widget.note.title} (${widget.note.content.length} chars)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colors.secondaryText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.elevatedCard,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Text(
                      'GROUNDED',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat Messages Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: copilot.messages.length,
                itemBuilder: (context, index) {
                  final msg = copilot.messages[index];
                  final isUser = msg.role == 'user';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? colors.primary.withValues(alpha: 0.12) : colors.card,
                              borderRadius: BorderRadius.circular(16).copyWith(
                                topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                                topRight: !isUser ? const Radius.circular(16) : const Radius.circular(4),
                              ),
                              border: Border.all(
                                color: isUser ? colors.primary.withValues(alpha: 0.3) : colors.border,
                                width: 1,
                              ),
                              boxShadow: [
                                colors.cardShadow,
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Text(
                                    msg.sourceIndicator.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: colors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                                Text(
                                  msg.content,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: colors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (copilot.isLoading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Copilot is reasoning from your note...',
                      style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],

            // Quick Prompt Chips
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final p = _quickPrompts[i];
                  return InkWell(
                    onTap: () => _sendQuery(p['prompt'] as String),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(p['icon'] as IconData, size: 13, color: colors.primary),
                          const SizedBox(width: 5),
                          Text(
                            p['label'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: colors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Input Bar
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: GoogleFonts.inter(fontSize: 13.5, color: colors.primaryText),
                        decoration: InputDecoration(
                          hintText: 'Ask anything about "${widget.note.title}"...',
                          hintStyle: GoogleFonts.inter(color: colors.mutedText, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onSubmitted: (val) => _sendQuery(val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                      onPressed: () => _sendQuery(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
