import '../models/user.dart';
import 'api_service.dart';
import 'mock_data_service.dart';
import 'storage_service.dart';

class AuthService {
  static Future<ApiResponse<User>> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final user = MockDataService.currentUser;
    await StorageService.saveToken('mock_jwt_token_${user.id}');
    await StorageService.saveUser(user);
    return ApiResponse(success: true, data: user, message: 'Welcome back!');
  }

  static Future<ApiResponse<User>> register({
    required String email,
    required String password,
    required String fullName,
    String? college,
    String? department,
    int? year,
    String? rollNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newUser = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      role: 'STUDENT',
      profile: Profile(
        id: 'profile-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user-${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        college: college ?? 'National Institute of Technology',
        department: department ?? 'CSE',
        year: year ?? 3,
        rollNumber: rollNumber ?? '21BCSE088',
        gpa: 8.7,
        careerScore: 78,
      ),
    );

    MockDataService.currentUser = newUser;
    await StorageService.saveToken('mock_jwt_token_${newUser.id}');
    await StorageService.saveUser(newUser);
    return ApiResponse(success: true, data: newUser, message: 'Account created!');
  }

  static Future<ApiResponse<User>> getMe() async {
    final user = StorageService.getUser() ?? MockDataService.currentUser;
    return ApiResponse(success: true, data: user);
  }

  static Future<ApiResponse<Profile>> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final current = MockDataService.currentUser.profile ?? Profile(
      id: 'profile-1',
      userId: MockDataService.currentUser.id,
      fullName: data['fullName'] ?? 'Student',
      college: data['college'] ?? '',
      department: data['department'] ?? 'CSE',
      year: data['year'] ?? 3,
      rollNumber: data['rollNumber'] ?? '',
    );

    final updated = Profile(
      id: current.id,
      userId: current.userId,
      fullName: data['fullName'] ?? current.fullName,
      avatarUrl: current.avatarUrl,
      college: data['college'] ?? current.college,
      department: data['department'] ?? current.department,
      year: data['year'] ?? current.year,
      rollNumber: data['rollNumber'] ?? current.rollNumber,
      gpa: (data['gpa'] != null) ? (data['gpa'] as num).toDouble() : current.gpa,
      careerScore: current.careerScore,
      studyHoursTotal: current.studyHoursTotal,
      bio: data['bio'] ?? current.bio,
      phone: data['phone'] ?? current.phone,
    );

    MockDataService.currentUser = User(
      id: MockDataService.currentUser.id,
      email: MockDataService.currentUser.email,
      role: MockDataService.currentUser.role,
      profile: updated,
    );

    await StorageService.saveUser(MockDataService.currentUser);
    return ApiResponse(success: true, data: updated);
  }

  static Future<ApiResponse<dynamic>> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      success: true,
      message: 'Password reset simulation link sent! Use demo login (student@demo.com / student123) for instant access.',
    );
  }

  static Future<void> logout() async {
    await StorageService.clearToken();
    await StorageService.clearUser();
  }
}
