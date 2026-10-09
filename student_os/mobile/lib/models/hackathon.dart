class Hackathon {
  final String id;
  final String name;
  final String organizer;
  final String date;
  final String mode;
  final String prize;
  final DateTime deadline;
  final String skills;
  final String category;
  final String description;
  final String? bannerUrl;
  final String? websiteUrl;

  Hackathon({
    required this.id,
    required this.name,
    required this.organizer,
    required this.date,
    required this.mode,
    required this.prize,
    required this.deadline,
    required this.skills,
    required this.category,
    required this.description,
    this.bannerUrl,
    this.websiteUrl,
  });

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      organizer: json['organizer'] ?? '',
      date: json['date'] ?? '',
      mode: json['mode'] ?? 'Online',
      prize: json['prize'] ?? '',
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now(),
      skills: json['skills'] ?? '',
      category: json['category'] ?? 'AI',
      description: json['description'] ?? '',
      bannerUrl: json['bannerUrl'],
      websiteUrl: json['websiteUrl'],
    );
  }

  List<String> get skillList => skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
