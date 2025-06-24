class NotificationModel {
  final String id;
  final String description;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.description,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      description: json['description'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
