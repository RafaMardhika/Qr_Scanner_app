class QrModel {
  final int id;
  final String title;
  final String content;
  final String type;
  final bool isActive;

  QrModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isActive,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: json['type'] ?? 'url',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}