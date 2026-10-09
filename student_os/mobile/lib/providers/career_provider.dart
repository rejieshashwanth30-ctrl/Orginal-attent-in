import 'package:flutter/material.dart';
import '../models/career_overview.dart';
import '../models/course.dart';
import '../models/hackathon.dart';
import '../models/internship.dart';
import '../models/job.dart';
import '../services/career_service.dart';

class CareerProvider extends ChangeNotifier {
  CareerOverviewData? _overview;
  List<Hackathon> _hackathons = [];
  List<Internship> _internships = [];
  List<Job> _jobs = [];
  List<Course> _courses = [];

  bool _isLoading = false;
  String? _error;

  CareerOverviewData? get overview => _overview;
  List<Hackathon> get hackathons => _hackathons;
  List<Internship> get internships => _internships;
  List<Job> get jobs => _jobs;
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllCareerData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final results = await Future.wait([
      CareerService.getOverview(),
      CareerService.getHackathons(),
      CareerService.getInternships(),
      CareerService.getJobs(),
      CareerService.getCourses(),
    ]);

    _isLoading = false;

    if (results[0].success && results[0].data != null) {
      _overview = results[0].data as CareerOverviewData;
    }
    if (results[1].success && results[1].data != null) {
      _hackathons = results[1].data as List<Hackathon>;
    }
    if (results[2].success && results[2].data != null) {
      _internships = results[2].data as List<Internship>;
    }
    if (results[3].success && results[3].data != null) {
      _jobs = results[3].data as List<Job>;
    }
    if (results[4].success && results[4].data != null) {
      _courses = results[4].data as List<Course>;
    }

    notifyListeners();
  }
}
