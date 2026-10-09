import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../models/note.dart';
import '../models/quiz.dart';
import '../models/subject.dart';
import '../services/flashcard_service.dart';
import '../services/subscription_service.dart';

class FlashcardProvider extends ChangeNotifier {
  FlashcardSet? _activeSet;
  int _currentCardIndex = 0;
  bool _isCardFlipped = false;
  bool _isLoading = false;
  String? _errorMessage;

  FlashcardSet? get activeSet => _activeSet;
  int get currentCardIndex => _currentCardIndex;
  bool get isCardFlipped => _isCardFlipped;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FlashcardSet> get sets => FlashcardService.sets;

  Flashcard? get currentCard {
    if (_activeSet == null ||
        _currentCardIndex < 0 ||
        _currentCardIndex >= _activeSet!.cards.length) {
      return null;
    }
    return _activeSet!.cards[_currentCardIndex];
  }

  bool get isLastCard {
    if (_activeSet == null) return true;
    return _currentCardIndex == _activeSet!.cards.length - 1;
  }

  void setActiveSet(FlashcardSet set) {
    _activeSet = set;
    _currentCardIndex = 0;
    _isCardFlipped = false;
    notifyListeners();
  }

  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  void rateCurrentCard(CardDifficulty rating) {
    if (_activeSet == null || currentCard == null) return;
    FlashcardService.updateCardRating(_activeSet!.id, currentCard!.id, rating);
    
    // Auto advance to next card
    if (!isLastCard) {
      _currentCardIndex++;
      _isCardFlipped = false;
    }
    notifyListeners();
  }

  void nextCard() {
    if (_activeSet == null) return;
    if (_currentCardIndex < _activeSet!.cards.length - 1) {
      _currentCardIndex++;
      _isCardFlipped = false;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_activeSet == null) return;
    if (_currentCardIndex > 0) {
      _currentCardIndex--;
      _isCardFlipped = false;
      notifyListeners();
    }
  }

  /// Generates a new flashcard deck
  Future<FlashcardSet?> generateFlashcards({
    required Subject subject,
    required String unit,
    required String topic,
    required int cardCount,
    required String difficulty,
    Note? sourceNote,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final set = await FlashcardService.generateFlashcards(
        subject: subject,
        unit: unit,
        topic: topic,
        cardCount: cardCount,
        difficulty: difficulty,
        sourceNote: sourceNote,
      );

      _activeSet = set;
      _currentCardIndex = 0;
      _isCardFlipped = false;
      SubscriptionService.recordFlashcardUsage();
      _isLoading = false;
      notifyListeners();
      return set;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to generate flashcards: $e';
      notifyListeners();
      return null;
    }
  }

  /// Automatically creates revision cards from quiz errors
  Future<FlashcardSet> createFromQuizMistakes(QuizResult quizResult) async {
    _isLoading = true;
    notifyListeners();

    final set = await FlashcardService.createFromQuizMistakes(quizResult: quizResult);
    _activeSet = set;
    _currentCardIndex = 0;
    _isCardFlipped = false;
    _isLoading = false;
    notifyListeners();
    return set;
  }
}
