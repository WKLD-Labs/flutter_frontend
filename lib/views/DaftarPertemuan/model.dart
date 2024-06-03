import 'dart:convert';

class Meeting {
  final int? id;
  final String meetingname;
  final String speaker;
  final String date;
  final String time;
  final String meetinglink;
  final String description;
  final String createdAt;
  final String updatedAt;

  Meeting({
    this.id,
    required this.meetingname,
    required this.speaker,
    required this.date,
    required this.time,
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
      date: json['date'],
      time: json['time'],
      meetinglink: json['meetinglink'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meetingname': meetingname,
      'speaker': speaker,
      'date': date,
      'time': time,
      'meetinglink': meetinglink,
      'description': description,
      'createdAt' : createdAt,
      'updatedAt' : updatedAt,
    };
  }

  static List<Meeting> meetingsFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Meeting>.from(data.map((item) => Meeting.fromJson(item)));
  }

  static String meetingsToJson(List<Meeting> data) {
    final jsonData = data.map((item) => item.toJson()).toList();
    return json.encode(jsonData);
  }
}