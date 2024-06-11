class RoomScheduleModel {
  final int? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RoomScheduleModel({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory RoomScheduleModel.fromJson(Map<String, dynamic> json) {
    return RoomScheduleModel(
      id: json['id'],
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'RoomScheduleModel(id: $id, name: $name, description: $description, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}