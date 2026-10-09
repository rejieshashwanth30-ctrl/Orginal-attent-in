import '../models/quiz.dart';
import '../models/note.dart';
import '../models/subject.dart';

class QuizService {
  static final List<QuizResult> _history = [];

  static List<QuizResult> get history => List.unmodifiable(_history);

  /// Generates a contextualized AI Quiz
  static Future<Quiz> generateQuiz({
    required String semester,
    required Subject subject,
    required String topic,
    required String difficulty,
    required int questionCount,
    required String questionType,
    bool isAdaptive = false,
    Note? sourceNote,
  }) async {
    // Simulate brief AI synthesis latency
    await Future.delayed(const Duration(milliseconds: 600));

    final questions = _buildQuestionsForSubject(
      subject: subject,
      topic: topic,
      difficulty: difficulty,
      questionCount: questionCount,
      questionType: questionType,
      sourceNote: sourceNote,
    );

    return Quiz(
      id: 'quiz-${DateTime.now().millisecondsSinceEpoch}',
      title: sourceNote != null
          ? 'Quiz: ${sourceNote.title}'
          : '${subject.name} — $topic',
      semester: semester,
      subjectId: subject.id,
      subjectName: subject.name,
      topic: topic,
      difficulty: difficulty,
      questions: questions,
      isAdaptive: isAdaptive,
      timeLimitMinutes: (questionCount * 1.5).ceil().clamp(5, 45),
      sourceNoteId: sourceNote?.id,
      sourceNoteTitle: sourceNote?.title,
    );
  }

  /// Evaluates completed quiz and compiles AI Diagnostic analysis
  static QuizResult evaluateQuiz({
    required Quiz quiz,
    required List<QuizQuestion> answeredQuestions,
    required int timeTakenSeconds,
  }) {
    int correctCount = 0;
    final Map<String, int> topicCorrect = {};
    final Map<String, int> topicTotal = {};

    for (final q in answeredQuestions) {
      final topic = q.topic;
      topicTotal[topic] = (topicTotal[topic] ?? 0) + 1;

      bool isCorrect = false;
      if (q.questionType == QuizQuestionType.mcq) {
        isCorrect = q.userSelection == q.correctAnswer;
      } else if (q.questionType == QuizQuestionType.trueFalse) {
        isCorrect = q.userSelection == q.correctAnswer;
      } else if (q.questionType == QuizQuestionType.multipleSelect) {
        if (q.userSelection is List && q.correctAnswer is List) {
          final userList = List<int>.from(q.userSelection as List)..sort();
          final correctList = List<int>.from(q.correctAnswer as List)..sort();
          isCorrect = userList.length == correctList.length &&
              userList.every((element) => correctList.contains(element));
        }
      }

      q.isAnsweredCorrectly = isCorrect;
      if (isCorrect) {
        correctCount++;
        topicCorrect[topic] = (topicCorrect[topic] ?? 0) + 1;
      }
    }

    final totalQuestions = answeredQuestions.length;
    final percentage = totalQuestions > 0
        ? ((correctCount / totalQuestions) * 100).roundToDouble()
        : 0.0;

    final List<String> strongTopics = [];
    final List<String> weakTopics = [];

    topicTotal.forEach((t, total) {
      final correct = topicCorrect[t] ?? 0;
      final ratio = correct / total;
      if (ratio >= 0.7) {
        strongTopics.add(t);
      } else {
        weakTopics.add(t);
      }
    });

    if (strongTopics.isEmpty && correctCount > 0) {
      strongTopics.add(quiz.topic);
    }
    if (weakTopics.isEmpty && correctCount < totalQuestions) {
      weakTopics.add('${quiz.topic} Edge Cases');
    }

    final List<String> aiRecommendations = [];
    if (weakTopics.isNotEmpty) {
      aiRecommendations.add('Review notes on ${weakTopics.take(2).join(' & ')}.');
      aiRecommendations.add('Practice 5 targeted flashcards for weak areas.');
    } else {
      aiRecommendations.add('Excellent mastery of ${quiz.subjectName}! Proceed to advanced level questions.');
    }

    String diffRec = 'Medium';
    if (percentage >= 80) {
      diffRec = 'Hard';
    } else if (percentage < 50) {
      diffRec = 'Easy';
    }

    final result = QuizResult(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      quizId: quiz.id,
      subjectName: quiz.subjectName,
      topic: quiz.topic,
      score: correctCount,
      totalQuestions: totalQuestions,
      percentage: percentage,
      correctCount: correctCount,
      incorrectCount: totalQuestions - correctCount,
      timeTakenSeconds: timeTakenSeconds,
      strongTopics: strongTopics.isEmpty ? ['Fundamental Concepts'] : strongTopics,
      weakTopics: weakTopics.isEmpty ? ['None detected'] : weakTopics,
      aiRecommendations: aiRecommendations,
      difficultyRecommendation: diffRec,
      suggestedNextQuiz: '${quiz.subjectName} — Advanced Mastery',
      questions: answeredQuestions,
    );

    _history.insert(0, result);
    return result;
  }

  // --- Internal Question Bank Generator grounded in Subject & Note Context ---
  static List<QuizQuestion> _buildQuestionsForSubject({
    required Subject subject,
    required String topic,
    required String difficulty,
    required int questionCount,
    required String questionType,
    Note? sourceNote,
  }) {
    final subName = subject.name.toLowerCase();
    List<QuizQuestion> bank = [];

    if (sourceNote != null) {
      // Grounded in uploaded note
      bank = [
        QuizQuestion(
          id: 'nq-1',
          question: 'According to "${sourceNote.title}", what is the primary formula or mechanism emphasized?',
          options: [
            'Attention(Q, K, V) = softmax(QK^T / sqrt(d_k))V',
            'Gradient Descent weight update: W = W - alpha * dW',
            'Cross-Entropy Loss computation: -sum(y * log(p))',
            'LR(1) canonical state item transitions',
          ],
          correctAnswer: 0,
          explanation: 'As documented in the selected note, scaled dot-product attention computes projection weights across Queries, Keys, and Values.',
          topic: sourceNote.title,
          difficulty: 'Medium',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'nq-2',
          question: 'True or False: Multi-Head Attention projects Q, K, and V into distinct subspaces simultaneously.',
          options: ['True', 'False'],
          correctAnswer: true,
          explanation: 'True. Multi-Head Attention enables the model to jointly attend to information from different representation subspaces at different positions.',
          topic: sourceNote.title,
          difficulty: 'Easy',
          questionType: QuizQuestionType.trueFalse,
        ),
        QuizQuestion(
          id: 'nq-3',
          question: 'Which of the following advantages are derived from the principles in this note?',
          options: [
            'Parallelizable sequence computation',
            'Direct token-to-token receptive field without recurrence',
            'Reduced positional encoding overhead',
            'O(1) memory complexity during full context decoding',
          ],
          correctAnswer: [0, 1],
          explanation: 'Attention mechanisms replace recurrence with parallelizable operations across all token positions simultaneously.',
          topic: sourceNote.title,
          difficulty: 'Hard',
          questionType: QuizQuestionType.multipleSelect,
        ),
        QuizQuestion(
          id: 'nq-4',
          question: 'What is the scaling factor sqrt(d_k) used for in the dot-product attention formula?',
          options: [
            'To prevent dot products from growing excessively large for high dimensions',
            'To convert logits directly into probabilities without softmax',
            'To enforce sparsity across unimportant tokens',
            'To align the dimensions between Query and Value vectors',
          ],
          correctAnswer: 0,
          explanation: 'Scaling by sqrt(d_k) prevents softmax gradients from vanishing when dot products grow large in high dimensional spaces.',
          topic: sourceNote.title,
          difficulty: 'Medium',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'nq-5',
          question: 'In deep Transformer architectures, why are Residual Connections and LayerNorm utilized?',
          options: [
            'To stabilize gradient flow and prevent vanishing/exploding gradients during backprop',
            'To reduce total model parameters by half',
            'To eliminate the need for activation functions',
            'To speed up CPU single-threaded execution',
          ],
          correctAnswer: 0,
          explanation: 'Residual connections allow uninterrupted gradient highways through deep layers.',
          topic: sourceNote.title,
          difficulty: 'Medium',
          questionType: QuizQuestionType.mcq,
        ),
      ];
    } else if (subName.contains('machine') || subName.contains('ml') || subName.contains('ai')) {
      bank = [
        QuizQuestion(
          id: 'ml-1',
          question: 'Which algorithm is commonly utilized for classification rather than linear regression?',
          options: ['Linear Regression', 'Logistic Regression', 'K-Means Clustering', 'Principal Component Analysis (PCA)'],
          correctAnswer: 1,
          explanation: 'Logistic Regression uses the sigmoid function to map predicted real values into [0, 1] class probabilities.',
          topic: 'Classification',
          difficulty: 'Easy',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'ml-2',
          question: 'What phenomenon occurs when a model fits the training data too closely and fails to generalize to unseen test data?',
          options: ['Underfitting', 'Overfitting', 'High Bias', 'Vanishing Gradient'],
          correctAnswer: 1,
          explanation: 'Overfitting occurs when a high-capacity model memorizes noise in the training set.',
          topic: 'Model Evaluation',
          difficulty: 'Easy',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'ml-3',
          question: 'Which of the following are unsupervised learning algorithms? (Select all that apply)',
          options: ['K-Means Clustering', 'Support Vector Machines (SVM)', 'DBSCAN', 'Linear Discriminant Analysis'],
          correctAnswer: [0, 2],
          explanation: 'K-Means and DBSCAN cluster unlabeled datasets without supervision.',
          topic: 'Clustering',
          difficulty: 'Medium',
          questionType: QuizQuestionType.multipleSelect,
        ),
        QuizQuestion(
          id: 'ml-4',
          question: 'True or False: In Backpropagation, gradients are propagated backwards from the loss function using the Chain Rule.',
          options: ['True', 'False'],
          correctAnswer: true,
          explanation: 'True. Backpropagation applies the calculus chain rule iteratively from the output loss back to initial weights.',
          topic: 'Neural Networks',
          difficulty: 'Medium',
          questionType: QuizQuestionType.trueFalse,
        ),
        QuizQuestion(
          id: 'ml-5',
          question: 'In Convolutional Neural Networks (CNN), what is the primary role of a Max Pooling layer?',
          options: [
            'Reduce spatial dimensions and computational load while providing translation invariance',
            'Apply non-linear activation to feature maps',
            'Compute class probabilities at the output stage',
            'Regularize weights using L2 weight decay',
          ],
          correctAnswer: 0,
          explanation: 'Max Pooling downsamples spatial dimensions (H x W) while retaining dominant feature activations.',
          topic: 'CNN & Computer Vision',
          difficulty: 'Hard',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'ml-6',
          question: 'Which loss function is optimal for training a multi-class neural network classifier with Softmax output?',
          options: ['Mean Squared Error (MSE)', 'Categorical Cross-Entropy', 'Binary Cross-Entropy', 'Hinge Loss'],
          correctAnswer: 1,
          explanation: 'Categorical Cross-Entropy measures divergence between true one-hot distributions and predicted softmax distributions.',
          topic: 'Loss Functions',
          difficulty: 'Hard',
          questionType: QuizQuestionType.mcq,
        ),
      ];
    } else if (subName.contains('compiler')) {
      bank = [
        QuizQuestion(
          id: 'comp-1',
          question: 'Which phase of a compiler converts source characters into a stream of meaningful tokens?',
          options: ['Lexical Analysis (Scanner)', 'Syntax Analysis (Parser)', 'Semantic Analysis', 'Code Optimization'],
          correctAnswer: 0,
          explanation: 'The Lexer scans raw source characters and maps regular expressions into tokens.',
          topic: 'Lexical Analysis',
          difficulty: 'Easy',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'comp-2',
          question: 'True or False: LL(1) parsers build parse trees from top-down with 1 lookahead token.',
          options: ['True', 'False'],
          correctAnswer: true,
          explanation: 'True. LL(1) stands for Left-to-right scanning, Leftmost derivation, with 1 token lookahead.',
          topic: 'Parsing Techniques',
          difficulty: 'Medium',
          questionType: QuizQuestionType.trueFalse,
        ),
        QuizQuestion(
          id: 'comp-3',
          question: 'Which of the following represent intermediate three-address code representations?',
          options: ['Quadruples', 'Triples', 'Indirect Triples', 'Symbol Tables'],
          correctAnswer: [0, 1, 2],
          explanation: 'Quadruples (op, arg1, arg2, result), Triples, and Indirect Triples are standard 3AC structures.',
          topic: 'Intermediate Code Generation',
          difficulty: 'Hard',
          questionType: QuizQuestionType.multipleSelect,
        ),
      ];
    } else {
      // General Computer Science & Data Structures
      bank = [
        QuizQuestion(
          id: 'gen-1',
          question: 'What is the average-case time complexity of searching an element in a balanced Binary Search Tree (AVL / Red-Black)?',
          options: ['O(1)', 'O(log N)', 'O(N)', 'O(N log N)'],
          correctAnswer: 1,
          explanation: 'Balanced BST tree height is bounded at O(log N), providing logarithmic lookup time.',
          topic: 'Trees & Data Structures',
          difficulty: 'Easy',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'gen-2',
          question: 'Which data structure follows the First-In First-Out (FIFO) ordering principle?',
          options: ['Stack', 'Queue', 'Binary Heap', 'Hash Table'],
          correctAnswer: 1,
          explanation: 'Queues enforce FIFO ordering (enqueue at back, dequeue from front).',
          topic: 'Data Structures',
          difficulty: 'Easy',
          questionType: QuizQuestionType.mcq,
        ),
        QuizQuestion(
          id: 'gen-3',
          question: 'Which of the following sorting algorithms guarantee O(N log N) worst-case time complexity? (Select all that apply)',
          options: ['Merge Sort', 'Heap Sort', 'Quick Sort', 'Bubble Sort'],
          correctAnswer: [0, 1],
          explanation: 'Merge Sort and Heap Sort consistently achieve O(N log N) even in worst-case scenarios.',
          topic: 'Algorithms',
          difficulty: 'Medium',
          questionType: QuizQuestionType.multipleSelect,
        ),
        QuizQuestion(
          id: 'gen-4',
          question: 'True or False: Dynamic Programming is applicable when a problem exhibits Optimal Substructure and Overlapping Subproblems.',
          options: ['True', 'False'],
          correctAnswer: true,
          explanation: 'True. DP stores solutions to overlapping subproblems to prevent exponential recomputations.',
          topic: 'Dynamic Programming',
          difficulty: 'Medium',
          questionType: QuizQuestionType.trueFalse,
        ),
      ];
    }

    // Adjust question list to requested questionCount
    List<QuizQuestion> resultList = List.from(bank);
    while (resultList.length < questionCount) {
      final index = resultList.length + 1;
      resultList.add(
        QuizQuestion(
          id: 'synth-$index',
          question: 'Explain the core architectural trade-off in $topic regarding performance vs memory footprint (#$index).',
          options: [
            'Spatial memoization increases throughput at the expense of RAM allocation',
            'Linear scans minimize memory overhead without impacting time complexity',
            'Recursive call stacks eliminate memory fragmentation entirely',
            'Garbage collection eliminates the need for computational complexity analysis',
          ],
          correctAnswer: 0,
          explanation: 'Space-time trade-offs allow algorithms to achieve faster execution by allocating auxiliary lookup tables.',
          topic: topic,
          difficulty: difficulty == 'Mixed' ? (index % 2 == 0 ? 'Hard' : 'Medium') : difficulty,
          questionType: QuizQuestionType.mcq,
        ),
      );
    }

    return resultList.take(questionCount).toList();
  }
}
