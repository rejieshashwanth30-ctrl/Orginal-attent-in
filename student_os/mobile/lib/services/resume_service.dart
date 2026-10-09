import '../models/resume.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class ResumeService {
  static Future<ApiResponse<Resume>> getResume() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(success: true, data: MockDataService.resume);
  }

  static Future<ApiResponse<Resume>> updateResume({
    String? title,
    String? objective,
    List<ResumeEducation>? education,
    List<ResumeExperience>? experience,
    List<ResumeProject>? projects,
    String? skills,
    List<String>? certifications,
    List<String>? achievements,
    String? languages,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final old = MockDataService.resume;
    final updated = Resume(
      id: old.id,
      userId: old.userId,
      title: title ?? old.title,
      objective: objective ?? old.objective,
      education: education ?? old.education,
      experience: experience ?? old.experience,
      projects: projects ?? old.projects,
      skills: skills ?? old.skills,
      certifications: certifications ?? old.certifications,
      achievements: achievements ?? old.achievements,
      languages: languages ?? old.languages,
    );
    MockDataService.resume = updated;
    return ApiResponse(success: true, data: updated);
  }
}
