class Document {
  final int? id;
  final String title;
  final String? writer;
  final String? description;
  final bool status;
  final String? borrower;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Document({
    this.id,
    required this.title,
    this.writer,
    this.description,
    required this.status,
    this.borrower,
    this.createdAt,
    this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'] ?? '',
      writer: json['writer'],
      description: json['description'],
      status: json['status'] ?? false,
      borrower: json['borrower'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'writer': writer,
      'description': description,
      'status': status,
      'borrower': borrower,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
