class SellerStats {
  final int totalSellers;
  final int pendingRequests;

  SellerStats({
    required this.totalSellers,
    required this.pendingRequests,
  });

  factory SellerStats.fromMap(Map<String, dynamic> map) {
    return SellerStats(
      totalSellers: map['totalSellers']?.toInt() ?? 0,
      pendingRequests: map['pendingRequests']?.toInt() ?? 0,
    );
  }
}