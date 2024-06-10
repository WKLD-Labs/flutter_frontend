class Inventory{
  final int? id;
  final String name;
  final int unit;
  final DateTime date;
  final String description;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inventory({
    this.id,
    required this.name,
    required this.unit,
    required this.date,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inventory.fromJson(Map<String, dynamic> json){
    return Inventory(
      id: json['id'],
      name: json['name'] ?? '',
      unit: json['unit'] ?? 0,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'date': date.toIso8601String(),
      'description': description,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}