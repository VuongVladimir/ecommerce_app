class Notification_Model {
  final String id;
  final String userId;
  final String sellerId;
  final String type;
  final String productId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  Notification_Model({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.type,
    required this.productId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification_Model.fromMap(Map<String, dynamic> map) {
    return Notification_Model(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      type: map['type'] ?? '',
      productId: map['productId'] ?? '',
      message: map['message'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}