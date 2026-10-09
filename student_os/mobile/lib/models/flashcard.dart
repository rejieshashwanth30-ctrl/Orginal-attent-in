enum CardDifficulty {
  easy,
  good,
  difficult,
}

class Flashcard {
  final String id;
  final String front;
  final String back;
  final String topic;
  CardDifficulty difficultyRating;
  DateTime? lastReviewedAt;
  int reviewCount;
  bool isMarkedDifficult;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.topic,
    this.difficultyRating = CardDifficulty.good,
    this.lastReviewedAt,
    this.reviewCount = 0,
    this.isMarkedDifficult = false,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    CardDifficulty rating = CardDifficulty.good;
    final diffStr = json['difficultyRating']?.toString().toLowerCase() ?? 'good';
    if (diffStr.contains('easy')) {
      rating = CardDifficulty.easy;
    } else if (diffStr.contains('diff') || diffStr.contains('hard')) {
      rating = CardDifficulty.difficult;
    }

    return Flashcard(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      front: json['front'] ?? '',
      back: json['back'] ?? '',
      topic: json['topic'] ?? 'General',
      difficultyRating: rating,
      reviewCount: json['reviewCount'] is int ? json['reviewCount'] : 0,
      isMarkedDifficult: json['isMarkedDifficult'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'topic': topic,
      'difficultyRating': difficultyRating.name,
      'reviewCount': reviewCount,
      'isMarkedDifficult': isMarkedDifficult,
    };
  }
}

class FlashcardSet {
  final String id;
  final String title;
  final String subjectId;
  final String subjectName;
  final String unit;
  final String topic;
  final List<Flashcard> cards;
  final String? sourceNoteId;
  final String? sourceNoteTitle;
  final bool isFromQuizMistakes;
  final DateTime createdAt;

  FlashcardSet({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.subjectName,
    required this.unit,
    required this.topic,
    required this.cards,
    this.sourceNoteId,
    this.sourceNoteTitle,
    this.isFromQuizMistakes = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalCards => cards.length;
  int get difficultCardsCount => cards.where((c) => c.difficultyRating == CardDifficulty.difficult || c.isMarkedDifficult).length;
  int get easyCardsCount => cards.where((c) => c.difficultyRating == CardDifficulty.easy).length;
  int get goodCardsCount => cards.where((c) => c.difficultyRating == CardDifficulty.good).length;
}
