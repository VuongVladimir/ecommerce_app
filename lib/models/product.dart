import 'dart:convert';

import 'package:ecommerce_app_fluterr_nodejs/models/rating.dart';

class Product {
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final String sellerId;
  final List<Rating>? ratings;
  final double? avgRating;
  final String? shopName;
  final String? shopAvatar;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    required this.sellerId,
    this.ratings,
    this.avgRating,
    this.shopName,
    this.shopAvatar,
  });
  // Chuyển đổi từ đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      '_id': id,
      'sellerId': sellerId, 
      'ratings': ratings,
      'avgRating': avgRating,
      'shopName': shopName,
      'shopAvatar': shopAvatar,
    };
  }

// Chuyển đổi từ Map thành đối tượng Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      id: map['_id'],
      sellerId: map['sellerId'] is Map ? map['sellerId']['_id'].toString() : (map['sellerId'] ?? ''),
      ratings: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
      avgRating: map['avgRating']?.toDouble() ?? 0.0,
      shopName: map['sellerId'] is Map ? map['sellerId']['shopName']?.toString() : map['shopName'],
      shopAvatar: map['sellerId'] is Map ? map['sellerId']['shopAvatar']?.toString() : map['shopAvatar'],
    );
  }

// Chuyển đổi đối tượng thành JSON
  String toJson() => json.encode(toMap());

// Chuyển đổi JSON thành đối tượng Product
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
