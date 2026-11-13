class Product {
  final String id;
  final String brandId;
  final String brandName;
  final String title;
  final String description;
  final double originalPrice;
  final double discountPrice;
  final String storeUrl;
  final String imageUrl;
  final bool isTrending;

  const Product({
    required this.id,
    required this.brandId,
    required this.brandName,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountPrice,
    required this.storeUrl,
    required this.imageUrl,
    this.isTrending = true,
  });

  int get discountPercentage =>
      originalPrice > 0 ? (((originalPrice - discountPrice) / originalPrice) * 100).round() : 0;
}

