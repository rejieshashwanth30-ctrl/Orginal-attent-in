class NotesCopilotMessage {
  final String id;
  final String role; // "user" or "copilot"
  final String content;
  final DateTime timestamp;
  final String sourceIndicator; // "Based on your uploaded notes" or "Additional explanation"

  NotesCopilotMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.sourceIndicator = 'Based on your uploaded notes',
  });
}

class CopilotQuickPrompt {
  final String label;
  final String prompt;
  final String icon;

  CopilotQuickPrompt({
    required this.label,
    required this.prompt,
    required this.icon,
  });
}
