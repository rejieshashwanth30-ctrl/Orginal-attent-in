class Internship {
  final String id;
  final String company;
  final String role;
  final String location;
  final String mode; // Remote, Hybrid, On-site
  final String stipend;
  final String duration;
  final DateTime deadline;
  final String skills;
  final String description;
  final String? applyUrl;

  Internship({
    required this.id,
    required this.company,
    required this.role,
    required this.location,
    required this.mode,
    required this.stipend,
    required this.duration,
    required this.deadline,
    required this.skills,
    required this.description,
    this.applyUrl,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      role: json['role'] ?? '',
      location: json['location'] ?? '',
      mode: json['mode'] ?? 'Remote',
      stipend: json['stipend'] ?? '',
      duration: json['duration'] ?? '',
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now(),
      skills: json['skills'] ?? '',
      description: json['description'] ?? '',
      applyUrl: json['applyUrl'],
    );
  }

  List<String> get skillList => skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
