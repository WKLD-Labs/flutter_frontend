import 'dart:convert';

class MemberData {
  final int? id;
  late final String? name;
  late final String? studentId;
  late final String? className;
  late final String? department;
  late final String? faculty;
  late final String? major;
  late final int? entryYear;
  late final int? age;

  MemberData({
    this.id,
    required this.name,
    required this.studentId,
    required this.className,
    required this.department,
    required this.faculty,
    required this.major,
    required this.entryYear,
    this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'className': className,
      'department': department,
      'faculty': faculty,
      'major': major,
      'entryYear': entryYear,
      'age': age,
    };
  }

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['id'],
      name: json['name'],
      studentId: json['studentId'],
      className: json['className'],
      department: json['department'],
      faculty: json['faculty'],
      major: json['major'],
      entryYear: json['entryYear'],
      age: json['age'],
    );
  }

  static List<MemberData> membersFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<MemberData>.from(data.map((item) => MemberData.fromJson(item)));
  }
}