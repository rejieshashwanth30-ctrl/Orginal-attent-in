import '../models/career_overview.dart';
import '../models/course.dart';
import '../models/hackathon.dart';
import '../models/internship.dart';
import '../models/job.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class CareerService {
  static Future<ApiResponse<CareerOverviewData>> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final data = CareerOverviewData(
      readinessScore: MockDataService.currentUser.profile?.careerScore ?? 78,
      technicalSkillsScore: 85,
      projectsScore: 80,
      atsResumeScore: 75,
      coursesScore: 70,
      interviewScore: 88,
      recommendedHackathonsCount: MockDataService.hackathons.length,
      activeInternshipsCount: MockDataService.internships.length,
      matchedJobsCount: MockDataService.jobs.length,
    );
    return ApiResponse(success: true, data: data);
  }

  static Future<ApiResponse<List<Hackathon>>> getHackathons({String? category, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.hackathons;
    if (category != null && category != 'All' && category.isNotEmpty) {
      list = list.where((h) => h.category.toLowerCase() == category.toLowerCase() || h.skills.toLowerCase().contains(category.toLowerCase())).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      list = list.where((h) => h.name.toLowerCase().contains(q) || h.organizer.toLowerCase().contains(q) || h.skills.toLowerCase().contains(q)).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<List<Internship>>> getInternships({String? mode, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.internships;
    if (mode != null && mode != 'All' && mode.isNotEmpty) {
      list = list.where((i) => i.mode.toLowerCase() == mode.toLowerCase()).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      list = list.where((i) => i.role.toLowerCase().contains(q) || i.company.toLowerCase().contains(q) || i.skills.toLowerCase().contains(q)).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<List<Job>>> getJobs({String? experience, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.jobs;
    if (experience != null && experience != 'All' && experience.isNotEmpty) {
      list = list.where((j) => j.experience.toLowerCase().contains(experience.toLowerCase())).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      list = list.where((j) => j.position.toLowerCase().contains(q) || j.company.toLowerCase().contains(q) || j.skills.toLowerCase().contains(q)).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<List<Course>>> getCourses({String? level, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.courses;
    if (level != null && level != 'All' && level.isNotEmpty) {
      list = list.where((c) => c.level.toLowerCase().contains(level.toLowerCase())).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      list = list.where((c) => c.name.toLowerCase().contains(q) || c.provider.toLowerCase().contains(q) || c.skills.toLowerCase().contains(q)).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }
}
