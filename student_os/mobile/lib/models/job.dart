class Job {
  final String id;
  final String company;
  final String position;
  final String location;
  final String salary;
  final String experience;
  final String skills;
  final DateTime deadline;
  final String description;
  final String? applyUrl;

  Job({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.salary,
    required this.experience,
    required this.skills,
    required this.deadline,
    required this.description,
    this.applyUrl,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      experience: json['experience'] ?? '',
      skills: json['skills'] ?? '',
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now(),
      description: json['description'] ?? '',
      applyUrl: json['applyUrl'],
    );
  }

  List<String> get skillList => skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
