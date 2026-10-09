import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';

class AchievementProvider extends ChangeNotifier {
  AchievementCategory? _selectedCategory;

  AchievementCategory? get selectedCategory => _selectedCategory;
  List<Achievement> get allAchievements => AchievementService.achievements;
  AchievementProgress get progress => AchievementService.getProgress();

  List<Achievement> get filteredAchievements {
    if (_selectedCategory == null) {
      return allAchievements;
    }
    return allAchievements.where((a) => a.category == _selectedCategory).toList();
  }

  void setCategory(AchievementCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
