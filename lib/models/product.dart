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
  final List<Rating>? ratings;
  final double? avgRating;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.ratings,
    this.avgRating,
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
      'ratings': ratings,
      'avgRating': avgRating,
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
      ratings: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
      avgRating: map['avgRating']?.toDouble() ?? 0.0
    );
  }

// Chuyển đổi đối tượng thành JSON
  String toJson() => json.encode(toMap());

// Chuyển đổi JSON thành đối tượng Product
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
