import '../models/skill.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class SkillService {
  static Future<ApiResponse<List<Skill>>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: List.from(MockDataService.skills));
  }

  static Future<ApiResponse<Skill>> addSkill({
    required String name,
    required int proficiency,
    required String category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final sk = Skill(
      id: 'sk-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      name: name,
      proficiency: proficiency,
      category: category,
    );
    MockDataService.skills.add(sk);
    return ApiResponse(success: true, data: sk);
  }

  static Future<ApiResponse<Skill>> updateSkill({
    required String id,
    String? name,
    int? proficiency,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.skills.indexWhere((s) => s.id == id);
    if (index != -1) {
      final old = MockDataService.skills[index];
      final updated = Skill(
        id: old.id,
        userId: old.userId,
        name: name ?? old.name,
        proficiency: proficiency ?? old.proficiency,
        category: category ?? old.category,
      );
      MockDataService.skills[index] = updated;
      return ApiResponse(success: true, data: updated);
    }
    return ApiResponse(success: false, message: 'Skill not found');
  }

  static Future<ApiResponse<dynamic>> deleteSkill(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDataService.skills.removeWhere((s) => s.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }
}
