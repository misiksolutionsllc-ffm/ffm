class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String imageUrl;
  final String farmerId;
  final String farmerName;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final bool inStock;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    required this.farmerId,
    required this.farmerName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOrganic = false,
    this.inStock = true,
    this.stockQuantity = 0,
  });

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? unit,
    String? category,
    String? imageUrl,
    bool? isOrganic,
    bool? inStock,
    int? stockQuantity,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      farmerId: farmerId,
      farmerName: farmerName,
      rating: rating,
      reviewCount: reviewCount,
      isOrganic: isOrganic ?? this.isOrganic,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}
