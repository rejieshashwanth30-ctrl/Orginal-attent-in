class Skill {
  final String id;
  final String userId;
  final String name;
  final int proficiency; // 0 - 100
  final String category; // TECHNICAL, SOFT, TOOL

  Skill({
    required this.id,
    required this.userId,
    required this.name,
    this.proficiency = 50,
    this.category = 'TECHNICAL',
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      proficiency: json['proficiency'] is int ? json['proficiency'] : 50,
      category: json['category'] ?? 'TECHNICAL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'proficiency': proficiency,
      'category': category,
    };
  }
}
