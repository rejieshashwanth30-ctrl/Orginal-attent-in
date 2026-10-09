import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../services/ai_service.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'content': 'Hello! I am **ATTENT-IN AI**, your academic and career copilot. I can help explain concepts, generate study schedules, write code, optimize your resume, or prepare you for technical interviews. How can I help you today?',
    }
  ];

  bool _isTyping = false;

  final List<String> _quickPrompts = [
    'Explain Transformer Self-Attention in 3 sentences',
    'How do I raise my attendance to 75%?',
    'Review my resume technical summary',
    'Give me 3 top Flutter interview questions',
    'Generate a 5-day study plan for Machine Learning',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userText = text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({'role': 'user', 'content': userText});
      _isTyping = true;
    });

    _scrollToBottom();

    // Call AI Service
    final res = await AIService.sendMessage(prompt: userText);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'role': 'assistant',
          'content': res.reply,
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final canPop = Navigator.canPop(context);

    // Calculate dynamic bottom padding so input sits naturally 10px above the floating dock
    final safeBottom = bottomInset > 0 ? bottomInset + 8.0 : 16.0;
    const dockHeight = 68.0;
    final composerBottom = isKeyboardOpen
        ? 8.0
        : (canPop
            ? (bottomInset > 0 ? bottomInset + 8.0 : 12.0)
            : (safeBottom + dockHeight + 10.0));

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                AppConstants.appLogo,
                fit: BoxFit.contain,
                semanticLabel: 'ATTENT-IN Logo',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ATTENT-IN AI',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryText),
                ),
                Text(
                  'Online • Academic Copilot',
                  style: GoogleFonts.inter(fontSize: 11, color: colors.accentCyan),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                // 1. Chat Message Stream
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser ? colors.subtleAccentBg : colors.card,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                              bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                            ),
                            border: Border.all(
                              color: isUser ? colors.primary.withValues(alpha: 0.5) : colors.border,
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 13, color: colors.accentCyan),
                                    const SizedBox(width: 5),
                                    Text(
                                      'ATTENT-IN AI',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: colors.accentCyan,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                              ],
                              Text(
                                msg['content'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  height: 1.45,
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

                // 2. Typing Indicator
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ATTENT-IN AI is reasoning...',
                          style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                        ),
                      ],
                    ),
                  ),

                // 3. Quick Prompt Chips
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: _quickPrompts.length,
                    itemBuilder: (context, index) {
                      final prompt = _quickPrompts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => _sendMessage(prompt),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: colors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.border, width: 1),
                              boxShadow: [colors.cardShadow],
                            ),
                            child: Text(
                              prompt,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: colors.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // 4. Message Composer
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, composerBottom),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.border, width: 1.2),
                      boxShadow: [
                        colors.cardShadow,
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            minLines: 1,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.send,
                            onSubmitted: _sendMessage,
                            style: GoogleFonts.inter(fontSize: 13.5, color: colors.primaryText),
                            decoration: InputDecoration(
                              hintText: 'Ask ATTENT-IN AI anything...',
                              hintStyle: GoogleFonts.inter(color: colors.mutedText, fontSize: 13),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [colors.primary, colors.accentCyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
                              tooltip: 'Send message',
                              onPressed: () => _sendMessage(_messageController.text),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
