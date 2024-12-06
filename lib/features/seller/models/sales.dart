class Sales {
  final String category;
  final double earning;

  Sales({
    required this.category,
    required this.earning,
  });

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      category: map['category'] ?? '',
      earning: (map['earning'] ?? 0).toDouble(),
    );
  }
}