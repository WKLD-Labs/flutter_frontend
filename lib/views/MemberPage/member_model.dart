class MemberData {
  final int? id;
  final String? name;
  final String? nim;
  final String? faculty;
  final String? major;
  final int? entryYear;

  MemberData({
    this.id,
    required this.name,
    required this.nim,
    required this.faculty,
    required this.major,
    required this.entryYear,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['id'],
      name: json['name'],
      nim: json['nim'],
      faculty: json['faculty'],
      major: json['major'],
      entryYear: json['entryYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nim': nim,
      'faculty': faculty,
      'major': major,
      'entryYear': entryYear,
    };
  }
}