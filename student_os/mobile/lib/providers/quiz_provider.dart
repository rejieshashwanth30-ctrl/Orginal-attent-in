import 'dart:async';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/quiz.dart';
import '../models/subject.dart';
import '../services/quiz_service.dart';
import '../services/subscription_service.dart';

class QuizProvider extends ChangeNotifier {
  Quiz? _activeQuiz;
  QuizResult? _lastResult;
  bool _isLoading = false;
  String? _errorMessage;

  int _currentQuestionIndex = 0;
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _showExplanation = false;

  Quiz? get activeQuiz => _activeQuiz;
  QuizResult? get lastResult => _lastResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get secondsElapsed => _secondsElapsed;
  bool get showExplanation => _showExplanation;
  List<QuizResult> get history => QuizService.history;

  QuizQuestion? get currentQuestion {
    if (_activeQuiz == null ||
        _currentQuestionIndex < 0 ||
        _currentQuestionIndex >= _activeQuiz!.questions.length) {
      return null;
    }
    return _activeQuiz!.questions[_currentQuestionIndex];
  }

  bool get isLastQuestion {
    if (_activeQuiz == null) return true;
    return _currentQuestionIndex == _activeQuiz!.questions.length - 1;
  }

  /// Generate and start a new quiz
  Future<bool> generateQuiz({
    required String semester,
    required Subject subject,
    required String topic,
    required String difficulty,
    required int questionCount,
    required String questionType,
    bool isAdaptive = false,
    Note? sourceNote,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final quiz = await QuizService.generateQuiz(
        semester: semester,
        subject: subject,
        topic: topic,
        difficulty: difficulty,
        questionCount: questionCount,
        questionType: questionType,
        isAdaptive: isAdaptive,
        sourceNote: sourceNote,
      );

      _activeQuiz = quiz;
      _currentQuestionIndex = 0;
      _secondsElapsed = 0;
      _showExplanation = false;
      _startTimer();

      SubscriptionService.recordQuizUsage();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to generate quiz: $e';
      notifyListeners();
      return false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Select answer for current question
  void selectOption(dynamic optionValue) {
    if (currentQuestion == null) return;
    final q = currentQuestion!;

    if (q.questionType == QuizQuestionType.multipleSelect) {
      if (optionValue is List) {
        q.userSelection = List<int>.from(optionValue);
      } else if (optionValue is int) {
        List<int> currentSelections = [];
        if (q.userSelection is List) {
          currentSelections = List<int>.from(q.userSelection as List);
        }
        if (currentSelections.contains(optionValue)) {
          currentSelections.remove(optionValue);
        } else {
          currentSelections.add(optionValue);
        }
        q.userSelection = currentSelections;
      }
    } else {
      q.userSelection = optionValue;
    }
    notifyListeners();
  }

  void toggleExplanation() {
    _showExplanation = !_showExplanation;
    notifyListeners();
  }

  /// Navigate to next question or submit quiz
  bool nextQuestion() {
    if (_activeQuiz == null) return false;
    if (_currentQuestionIndex < _activeQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      _showExplanation = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  void previousQuestion() {
    if (_activeQuiz == null) return;
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _showExplanation = false;
      notifyListeners();
    }
  }

  /// Finalizes quiz submission and computes results
  QuizResult? submitQuiz() {
    if (_activeQuiz == null) return null;
    _stopTimer();

    final result = QuizService.evaluateQuiz(
      quiz: _activeQuiz!,
      answeredQuestions: _activeQuiz!.questions,
      timeTakenSeconds: _secondsElapsed,
    );

    _lastResult = result;
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
