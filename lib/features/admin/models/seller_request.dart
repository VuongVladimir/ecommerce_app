import 'dart:convert';

class SellerRequest {
  final String id;
  final String userId;
  final String shopName;
  final String shopDescription;
  final String avatarUrl;
  final String status;
  final DateTime createdAt;
  final String userName;    // Thêm field mới
  final String userEmail;

  SellerRequest({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.shopDescription,
    required this.avatarUrl,
    required this.status,
    required this.createdAt,
    required this.userName,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'shopName': shopName,
      'shopDescription': shopDescription,
      'avatarUrl': avatarUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  // factory SellerRequest.fromMap(Map<String, dynamic> map) {
  //   return SellerRequest(
  //     id: map['_id'] ?? '',
  //     userId: map['userId'] ?? '',
  //     shopName: map['shopName'] ?? '',
  //     shopDescription: map['shopDescription'] ?? '',
  //     avatarUrl: map['avatarUrl'] ?? '',
  //     status: map['status'] ?? '',
  //     createdAt: DateTime.parse(map['createdAt']),
  //   );
  // }
  factory SellerRequest.fromMap(Map<String, dynamic> map) {
    return SellerRequest(
      id: map['_id']?.toString() ?? '',
      userId: map['userId']?['_id']?.toString() ?? '',
      userName: map['userId']?['name']?.toString() ?? '',
      userEmail: map['userId']?['email']?.toString() ?? '',
      shopName: map['shopName']?.toString() ?? '',
      shopDescription: map['shopDescription']?.toString() ?? '',
      avatarUrl: map['avatarUrl']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SellerRequest.fromJson(String source) =>
      SellerRequest.fromMap(json.decode(source));
}