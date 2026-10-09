import '../models/flashcard.dart';
import '../models/note.dart';
import '../models/quiz.dart';
import '../models/subject.dart';

class FlashcardService {
  static final List<FlashcardSet> _sets = [
    FlashcardSet(
      id: 'set-1',
      title: 'Machine Learning — Core Concepts',
      subjectId: 'sub-1',
      subjectName: 'Machine Learning',
      unit: 'Unit 2',
      topic: 'Supervised Learning & Regression',
      cards: [
        Flashcard(
          id: 'fc-1',
          front: 'What is Overfitting in Machine Learning models?',
          back: 'Overfitting occurs when a model learns the training data and noise too closely, failing to generalize to unseen test data. Mitigated via Regularization (L1/L2), Dropout, and Early Stopping.',
          topic: 'Generalization',
          difficultyRating: CardDifficulty.good,
        ),
        Flashcard(
          id: 'fc-2',
          front: 'State the mathematical formulation of the Sigmoid activation function.',
          back: 'σ(z) = 1 / (1 + e^(-z))\nMaps any real-valued number into the range (0, 1), standard for binary classification.',
          topic: 'Activation Functions',
          difficultyRating: CardDifficulty.easy,
        ),
        Flashcard(
          id: 'fc-3',
          front: 'How does Backpropagation compute weight updates in Neural Networks?',
          back: 'Backpropagation applies the Calculus Chain Rule recursively backwards from the loss output to compute the partial derivative (gradient) of the loss with respect to each weight.',
          topic: 'Backpropagation',
          difficultyRating: CardDifficulty.difficult,
          isMarkedDifficult: true,
        ),
        Flashcard(
          id: 'fc-4',
          front: 'Explain the difference between L1 (Lasso) and L2 (Ridge) Regularization.',
          back: 'L1 adds the absolute sum of weights (|w|) and induces sparsity (feature selection). L2 adds the squared sum (w^2) and shrinks weights smoothly towards zero without setting them to exact zero.',
          topic: 'Regularization',
          difficultyRating: CardDifficulty.good,
        ),
        Flashcard(
          id: 'fc-5',
          front: 'What is the role of the Learning Rate (α) in Gradient Descent?',
          back: 'It determines the step size taken towards the minimum of the loss function during weight updates: W = W - α * ∇Loss.',
          topic: 'Optimization',
          difficultyRating: CardDifficulty.easy,
        ),
      ],
    ),
    FlashcardSet(
      id: 'set-2',
      title: 'Compiler Design — Lexical & Parsing Tables',
      subjectId: 'sub-3',
      subjectName: 'Compiler Design',
      unit: 'Unit 1 & 2',
      topic: 'Grammars & Parsing',
      cards: [
        Flashcard(
          id: 'fc-6',
          front: 'What is the primary function of the Lexical Analyzer (Scanner)?',
          back: 'Reads source stream characters and groups them into meaningful token sequences (id, keyword, operator) while stripping whitespace and comments.',
          topic: 'Lexing',
          difficultyRating: CardDifficulty.easy,
        ),
        Flashcard(
          id: 'fc-7',
          front: 'Differentiate between Top-Down vs Bottom-Up Parsers.',
          back: 'Top-down constructs parse trees from the start symbol down to terminals (e.g. LL(1)). Bottom-up reduces terminals back to start symbol (e.g. LR(0), SLR(1), LALR(1), CLR(1)).',
          topic: 'Parsing',
          difficultyRating: CardDifficulty.good,
        ),
        Flashcard(
          id: 'fc-8',
          front: 'What causes Shift-Reduce and Reduce-Reduce conflicts in LR parsers?',
          back: 'Grammar ambiguities where the parser cannot decide whether to shift the next input token or reduce the handle according to a production rule.',
          topic: 'LR Parsing',
          difficultyRating: CardDifficulty.difficult,
          isMarkedDifficult: true,
        ),
      ],
    ),
  ];

  static List<FlashcardSet> get sets => List.unmodifiable(_sets);

  /// Generates a customized flashcard deck
  static Future<FlashcardSet> generateFlashcards({
    required Subject subject,
    required String unit,
    required String topic,
    required int cardCount,
    required String difficulty,
    Note? sourceNote,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<Flashcard> generatedCards = [];

    if (sourceNote != null) {
      generatedCards = [
        Flashcard(
          id: 'fcn-1',
          front: 'What is the core takeaway of "${sourceNote.title}"?',
          back: sourceNote.content.length > 150
              ? '${sourceNote.content.substring(0, 150)}...'
              : sourceNote.content,
          topic: sourceNote.title,
          difficultyRating: CardDifficulty.good,
        ),
        Flashcard(
          id: 'fcn-2',
          front: 'What mathematical or conceptual formulation is highlighted in this note?',
          back: 'Scaled Dot-Product Attention: Attention(Q,K,V) = softmax(QK^T / sqrt(d_k))V',
          topic: sourceNote.title,
          difficultyRating: CardDifficulty.easy,
        ),
        Flashcard(
          id: 'fcn-3',
          front: 'How does this concept improve computational performance or system design?',
          back: 'Eliminates sequential recurrence, enabling massive multi-core GPU/TPU matrix parallelization during training and inference.',
          topic: sourceNote.title,
          difficultyRating: CardDifficulty.good,
        ),
      ];
    } else {
      generatedCards = [
        Flashcard(
          id: 'fcg-1',
          front: 'Define $topic and its primary objective in ${subject.name}.',
          back: '$topic forms the foundational framework in ${subject.name} for solving scalable computational problems efficiently.',
          topic: topic,
          difficultyRating: CardDifficulty.easy,
        ),
        Flashcard(
          id: 'fcg-2',
          front: 'What are the key mathematical or algorithmic properties of $topic?',
          back: '1. Strict asymptotic complexity bounds\n2. Deterministic state transitions\n3. Memory footprint optimization',
          topic: topic,
          difficultyRating: CardDifficulty.good,
        ),
        Flashcard(
          id: 'fcg-3',
          front: 'Identify a common pitfall or edge case when implementing $topic.',
          back: 'Failure to account for boundary limits, non-converging gradients, or recursion depth overflows under high-frequency workloads.',
          topic: topic,
          difficultyRating: CardDifficulty.difficult,
          isMarkedDifficult: true,
        ),
      ];
    }

    while (generatedCards.length < cardCount) {
      final idx = generatedCards.length + 1;
      generatedCards.add(
        Flashcard(
          id: 'fcg-$idx',
          front: 'Key Principle #$idx for $topic ($unit)',
          back: 'Essential review point: Master foundational formulas and practical implementations for $topic.',
          topic: topic,
          difficultyRating: CardDifficulty.good,
        ),
      );
    }

    final newSet = FlashcardSet(
      id: 'set-${DateTime.now().millisecondsSinceEpoch}',
      title: sourceNote != null ? 'Flashcards: ${sourceNote.title}' : '${subject.name} — $topic',
      subjectId: subject.id,
      subjectName: subject.name,
      unit: unit,
      topic: topic,
      cards: generatedCards.take(cardCount).toList(),
      sourceNoteId: sourceNote?.id,
      sourceNoteTitle: sourceNote?.title,
    );

    _sets.insert(0, newSet);
    return newSet;
  }

  /// Automatically generates revision flashcards from quiz mistakes
  static Future<FlashcardSet> createFromQuizMistakes({
    required QuizResult quizResult,
  }) async {
    final incorrectQuestions = quizResult.questions.where((q) => q.isAnsweredCorrectly == false).toList();

    final List<Flashcard> mistakeCards = incorrectQuestions.map((q) {
      String answerText = q.correctAnswer.toString();
      if (q.questionType == QuizQuestionType.mcq && q.correctAnswer is int) {
        final idx = q.correctAnswer as int;
        if (idx >= 0 && idx < q.options.length) {
          answerText = q.options[idx];
        }
      }

      return Flashcard(
        id: 'fc-mistake-${q.id}',
        front: q.question,
        back: 'Correct Answer:\n$answerText\n\nExplanation:\n${q.explanation}',
        topic: q.topic,
        difficultyRating: CardDifficulty.difficult,
        isMarkedDifficult: true,
      );
    }).toList();

    final newSet = FlashcardSet(
      id: 'set-mistakes-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Quiz Mistakes: ${quizResult.subjectName}',
      subjectId: 'sub-review',
      subjectName: quizResult.subjectName,
      unit: 'Targeted Review',
      topic: quizResult.topic,
      cards: mistakeCards,
      isFromQuizMistakes: true,
    );

    _sets.insert(0, newSet);
    return newSet;
  }

  /// Updates difficulty rating for a card and updates spaced repetition state
  static void updateCardRating(String setId, String cardId, CardDifficulty rating) {
    for (final set in _sets) {
      if (set.id == setId) {
        for (final card in set.cards) {
          if (card.id == cardId) {
            card.difficultyRating = rating;
            card.lastReviewedAt = DateTime.now();
            card.reviewCount++;
            card.isMarkedDifficult = (rating == CardDifficulty.difficult);
            break;
          }
        }
      }
    }
  }
}
