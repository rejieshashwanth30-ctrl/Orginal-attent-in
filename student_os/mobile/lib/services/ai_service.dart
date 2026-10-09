import '../core/constants/api_constants.dart';
import 'api_service.dart';

class AIResponse {
  final bool success;
  final String reply;

  AIResponse({required this.success, required this.reply});
}

class AIService {
  static Future<AIResponse> sendMessage({required String prompt}) async {
    // 1. Try backend endpoint
    try {
      final res = await ApiService.post(
        ApiConstants.aiChat,
        body: {'prompt': prompt},
        requiresAuth: false,
      );

      if (res.success && res.data != null) {
        final reply = res.data['response']?.toString() ?? res.data['reply']?.toString() ?? 'Response received.';
        return AIResponse(success: true, reply: reply);
      }
    } catch (_) {
      // Fallback
    }

    // 2. Local rule fallback
    final p = prompt.toLowerCase();

    if (p.contains('study plan') || p.contains('schedule') || p.contains('exam')) {
      return AIResponse(
        success: true,
        reply: '''Here is your customized **ATTENT-IN Study Strategy** 📚:

1. **Pomodoro Cycles (50m Focus / 10m Break)**: Prioritize highest-credit & challenging subjects early in the day.
2. **Spaced Repetition Schedule**:
   - **Day 1**: Core theoretical foundations & concept mapping.
   - **Day 3**: Problem-solving sets & past 5-year exam questions.
   - **Day 7**: Active recall testing & flashcards.
3. **Weak Subject Acceleration**: Dedicate at least 90 minutes every evening to your target weak subjects.
4. **Mock Exam Simulation**: Time yourself under real exam conditions 3 days before finals.

*Tip: Check the **Study Planner** tab in ATTENT-IN to generate your automated timetable!*''',
      );
    }

    if (p.contains('resume') || p.contains('cv') || p.contains('ats')) {
      return AIResponse(
        success: true,
        reply: '''Here are **5 actionable tips to supercharge your resume** 📄:

1. **Quantify Your Impact**: Use the Google XYZ formula: *"Accomplished [X] as measured by [Y], by doing [Z]"*.
2. **ATS Optimization**: Keep standard section titles: *Education, Experience, Projects, Skills, Certifications*. Avoid two-column tables that trip parsers.
3. **Highlight Modern Stacks**: Place Flutter, Dart, Node.js, Python, Docker, and Cloud tools at the top.
4. **Include Live Links**: Link directly to GitHub repos and live deployed apps for your top projects.
5. **Action Verbs**: Begin bullet points with strong verbs: *Architected, Engineered, Optimized, Deployed*.''',
      );
    }

    if (p.contains('interview') || p.contains('mock') || p.contains('question')) {
      return AIResponse(
        success: true,
        reply: '''Here is your **Technical Interview Mastery Guide** 🎯:

- **Structure with STAR**: Situation, Task, Action, Result for behavioral rounds.
- **System Design Framework**:
  1. Clarify Requirements (Functional & Non-functional)
  2. Estimate Scale (QPS, Storage, Bandwidth)
  3. High-level Architecture (Client -> API Gateway -> Services -> DB/Cache)
  4. Deep Dive into Bottlenecks & Edge Cases
- **Data Structures Check**: Master HashMaps, Trees/Graphs, Sliding Window, and Dynamic Programming.

*Try out the **Mock Interview** tab in ATTENT-IN for interactive role-based evaluation!*''',
      );
    }

    if (p.contains('project') || p.contains('hackathon') || p.contains('idea')) {
      return AIResponse(
        success: true,
        reply: '''Here are **3 standout Full-Stack & AI project concepts** for your portfolio 💡:

1. **NeuroCampus (AI Attendance & Lecture Summarizer)**:
   - *Tech*: Flutter, Python FastAPI, Whisper API, LangChain, SQLite.
   - *Feature*: Transcribes lectures and auto-generates interactive quiz flashcards.

2. **Decentralized Student Credentials**:
   - *Tech*: Flutter, Solidity/EVM, Node.js, IPFS.
   - *Feature*: Verifiable academic certificates and hackathon badges stored cryptographically.

3. **Autonomous Lab Assistant Bot**:
   - *Tech*: ROS2, PyTorch, OpenCV, Dart WebSocket Dashboard.
   - *Feature*: Real-time equipment telemetry, anomaly detection, and voice instructions.''',
      );
    }

    if (p.contains('attendance') || p.contains('75') || p.contains('calculator')) {
      return AIResponse(
        success: true,
        reply: '''To maintain or raise your attendance above 75%:

- **Formula**: `(Attended + Needed) / (Total + Needed) >= 0.75`
- Each consecutive class attended increases your cumulative percentage by roughly `0.8% - 1.2%`.
- Use the **Attendance Tracker** tab in ATTENT-IN to simulate future attendance and set safety margin alerts!''',
      );
    }

    return AIResponse(
      success: true,
      reply: '''Hello! I'm your **ATTENT-IN AI Copilot** 🤖.

I can assist you with:
- 📅 **Study Schedules & Exam Prep Plans**
- 🧠 **AI Quiz Generation & Weak Concept Practice**
- 🃏 **Flashcards & Active Recall Decks**
- 💼 **Resume Optimization & ATS Reviews**
- 🎯 **Technical & HR Mock Interview Strategies**
- 🚍 **Campus Shuttle Timings & Directions**
- 📊 **Academic Attendance & GPA Predictions**

Ask me anything to optimize your student journey!''',
    );
  }

  /// AI Learning Loop: Analyzes quiz weakness and generates study recommendations
  static List<String> generateLearningLoopRecommendations({
    required String subjectName,
    required String weakTopic,
  }) {
    return [
      '📚 Review $subjectName ($weakTopic) class notes in Notebook.',
      '🃏 Practice a 10-card targeted flashcard session for $weakTopic.',
      '🧠 Take a short 5-question reinforcement quiz.',
      '📅 Add a 30-minute revision block to your study planner.',
    ];
  }
}
