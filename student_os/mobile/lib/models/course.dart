class Course {
  final String id;
  final String name;
  final String provider;
  final String level;
  final String duration;
  final String skills;
  final double rating;
  final String description;
  final String? url;

  Course({
    required this.id,
    required this.name,
    required this.provider,
    required this.level,
    required this.duration,
    required this.skills,
    this.rating = 4.8,
    required this.description,
    this.url,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      provider: json['provider'] ?? '',
      level: json['level'] ?? 'Intermediate',
      duration: json['duration'] ?? '',
      skills: json['skills'] ?? '',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 4.8,
      description: json['description'] ?? '',
      url: json['url'],
    );
  }

  List<String> get skillList => skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
