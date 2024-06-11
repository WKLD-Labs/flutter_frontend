
class Meeting {
  final int? id;
  final String? meetingname;
  final String? speaker;
  final DateTime? datetime;
  final String? meetinglink;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meeting({
    this.id,
    required this.meetingname,
    required this.speaker,
    required this.datetime, 
    required this.meetinglink,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      meetingname: json['meetingname'],
      speaker: json['speaker'],
      datetime: json['datetime'] != null ? DateTime.parse(json['datetime']) : null,
      meetinglink: json['meetinglink'],
      description: json['description'],
      createdAt: json['createdAt']!= null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt']!= null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meetingname': meetingname,
      'speaker': speaker,
      'datetime': datetime?.toIso8601String(),
      'meetinglink': meetinglink,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
