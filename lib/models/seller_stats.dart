class SellerStats {
  final String id;
  final String shopName;
  final String shopAvatar;
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;

  SellerStats({
    required this.id,
    required this.shopName,
    required this.shopAvatar,
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
  });

  factory SellerStats.fromMap(Map<String, dynamic> map) {
    return SellerStats(
      id: map['_id'] ?? '',
      shopName: map['shopName'] ?? '',
      shopAvatar: map['shopAvatar'] ?? '',
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      totalOrders: map['totalOrders']?.toInt() ?? 0,
      totalProducts: map['totalProducts']?.toInt() ?? 0,
    );
  }
}