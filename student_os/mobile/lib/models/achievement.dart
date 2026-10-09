enum AchievementCategory {
  academic,
  career,
  campus,
  learning,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon; // Icon name or emoji
  final AchievementCategory category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int progress;
  final int target;
  final String unit;
  final int rewardPoints;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.progress,
    required this.target,
    this.unit = '',
    this.rewardPoints = 50,
  });

  double get progressPercentage {
    if (target <= 0) return isUnlocked ? 1.0 : 0.0;
    return (progress / target).clamp(0.0, 1.0);
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    AchievementCategory cat = AchievementCategory.academic;
    final catStr = json['category']?.toString().toLowerCase() ?? 'academic';
    if (catStr.contains('career')) {
      cat = AchievementCategory.career;
    } else if (catStr.contains('campus')) {
      cat = AchievementCategory.campus;
    } else if (catStr.contains('learning')) {
      cat = AchievementCategory.learning;
    }

    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🏆',
      category: cat,
      isUnlocked: json['isUnlocked'] == true,
      unlockedAt: json['unlockedAt'] != null ? DateTime.tryParse(json['unlockedAt']) : null,
      progress: json['progress'] is int ? json['progress'] : int.tryParse(json['progress']?.toString() ?? '0') ?? 0,
      target: json['target'] is int ? json['target'] : int.tryParse(json['target']?.toString() ?? '1') ?? 1,
      unit: json['unit'] ?? '',
      rewardPoints: json['rewardPoints'] is int ? json['rewardPoints'] : 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category.name,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
      'target': target,
      'unit': unit,
      'rewardPoints': rewardPoints,
    };
  }
}

class AchievementProgress {
  final int totalUnlocked;
  final int totalLocked;
  final int studyStreakDays;
  final List<String> aiGoalRecommendations;

  AchievementProgress({
    required this.totalUnlocked,
    required this.totalLocked,
    required this.studyStreakDays,
    required this.aiGoalRecommendations,
  });
}
