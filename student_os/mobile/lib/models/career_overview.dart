class CareerOverviewData {
  final int readinessScore;
  final int technicalSkillsScore;
  final int projectsScore;
  final int atsResumeScore;
  final int coursesScore;
  final int interviewScore;
  final int recommendedHackathonsCount;
  final int activeInternshipsCount;
  final int matchedJobsCount;

  CareerOverviewData({
    required this.readinessScore,
    required this.technicalSkillsScore,
    required this.projectsScore,
    required this.atsResumeScore,
    required this.coursesScore,
    required this.interviewScore,
    required this.recommendedHackathonsCount,
    required this.activeInternshipsCount,
    required this.matchedJobsCount,
  });

  int get score => readinessScore;

  Map<String, int> get breakdown => {
    'skills': technicalSkillsScore,
    'projects': projectsScore,
    'resume': atsResumeScore,
    'courses': coursesScore,
    'hackathons': 65,
    'internships': 60,
    'mockInterviews': interviewScore,
  };

  factory CareerOverviewData.fromJson(Map<String, dynamic> json) {
    return CareerOverviewData(
      readinessScore: json['readinessScore'] is int ? json['readinessScore'] : 78,
      technicalSkillsScore: json['technicalSkillsScore'] is int ? json['technicalSkillsScore'] : 85,
      projectsScore: json['projectsScore'] is int ? json['projectsScore'] : 80,
      atsResumeScore: json['atsResumeScore'] is int ? json['atsResumeScore'] : 75,
      coursesScore: json['coursesScore'] is int ? json['coursesScore'] : 70,
      interviewScore: json['interviewScore'] is int ? json['interviewScore'] : 88,
      recommendedHackathonsCount: json['recommendedHackathonsCount'] is int ? json['recommendedHackathonsCount'] : 4,
      activeInternshipsCount: json['activeInternshipsCount'] is int ? json['activeInternshipsCount'] : 4,
      matchedJobsCount: json['matchedJobsCount'] is int ? json['matchedJobsCount'] : 3,
    );
  }
}
