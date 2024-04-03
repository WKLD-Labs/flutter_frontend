class RoomScheduleModel {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoomScheduleModel({
    required this.id,
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
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}