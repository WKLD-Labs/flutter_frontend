import 'dart:convert';

class MemberData {
  final int? id;
  final String name;
  final int studentId;
  final String className;
  final String department;

  MemberData({
    this.id,
    required this.name,
    required this.studentId,
    required this.className,
    required this.department,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['id'],
      name: json['name'],
      studentId: json['studentId'],
      className: json['className'],
      department: json['department']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'className': className,
      'department': department,
    };
  }
  
  static List<MemberData> membersFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<MemberData>.from(data.map((item) => MemberData.fromJson(item)));
  }

  static String membersToJson(List<MemberData> data) {
    final jsonData = data.map((item) => item.toJson()).toList();
    return json.encode(jsonData);
  }
}