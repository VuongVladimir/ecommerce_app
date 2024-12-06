class ShopStats {
  final int totalProducts;
  final double avgRating;
  final int followerCount;

  ShopStats({
    required this.totalProducts,
    required this.avgRating,
    required this.followerCount,
  });

  factory ShopStats.fromJson(Map<String, dynamic> json) {
    return ShopStats(
      totalProducts: json['totalProducts'] ?? 0,
      avgRating: double.parse(json['avgRating'].toString()),
      followerCount: json['followerCount'] ?? 0,
    );
  }
}