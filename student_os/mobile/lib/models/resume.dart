import 'dart:convert';

class ResumeEducation {
  final String degree;
  final String institution;
  final String year;
  final String gpa;

  ResumeEducation({
    required this.degree,
    required this.institution,
    required this.year,
    required this.gpa,
  });

  factory ResumeEducation.fromJson(Map<String, dynamic> json) {
    return ResumeEducation(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      year: json['year'] ?? '',
      gpa: json['gpa'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'degree': degree,
    'institution': institution,
    'year': year,
    'gpa': gpa,
  };
}

class ResumeExperience {
  final String role;
  final String company;
  final String duration;
  final String description;

  ResumeExperience({
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
  });

  factory ResumeExperience.fromJson(Map<String, dynamic> json) {
    return ResumeExperience(
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'company': company,
    'duration': duration,
    'description': description,
  };
}

class ResumeProject {
  final String title;
  final String tech;
  final String description;

  ResumeProject({
    required this.title,
    required this.tech,
    required this.description,
  });

  factory ResumeProject.fromJson(Map<String, dynamic> json) {
    return ResumeProject(
      title: json['title'] ?? '',
      tech: json['tech'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'tech': tech,
    'description': description,
  };
}

class Resume {
  final String id;
  final String userId;
  final String title;
  final String? objective;
  final List<ResumeEducation> education;
  final List<ResumeExperience> experience;
  final List<ResumeProject> projects;
  final String skills;
  final List<String> certifications;
  final List<String> achievements;
  final String languages;

  Resume({
    required this.id,
    required this.userId,
    this.title = 'My Tech Resume',
    this.objective,
    this.education = const [],
    this.experience = const [],
    this.projects = const [],
    this.skills = '',
    this.certifications = const [],
    this.achievements = const [],
    this.languages = '',
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    List<ResumeEducation> eduList = [];
    if (json['education'] != null) {
      final raw = json['education'];
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is List) {
        eduList = list.map((e) => ResumeEducation.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    List<ResumeExperience> expList = [];
    if (json['experience'] != null) {
      final raw = json['experience'];
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is List) {
        expList = list.map((e) => ResumeExperience.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    List<ResumeProject> projList = [];
    if (json['projects'] != null) {
      final raw = json['projects'];
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is List) {
        projList = list.map((e) => ResumeProject.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    List<String> certList = [];
    if (json['certifications'] != null) {
      final raw = json['certifications'];
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is List) {
        certList = list.map((c) => c.toString()).toList();
      }
    }

    List<String> achList = [];
    if (json['achievements'] != null) {
      final raw = json['achievements'];
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is List) {
        achList = list.map((a) => a.toString()).toList();
      }
    }

    return Resume(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'My Tech Resume',
      objective: json['objective'],
      education: eduList,
      experience: expList,
      projects: projList,
      skills: json['skills'] ?? '',
      certifications: certList,
      achievements: achList,
      languages: json['languages'] ?? '',
    );
  }
}
