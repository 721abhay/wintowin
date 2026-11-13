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

  Product copyWith({
    String? id,
    String? brandId,
    String? brandName,
    String? title,
    String? description,
    double? originalPrice,
    double? discountPrice,
    String? storeUrl,
    String? imageUrl,
    bool? isTrending,
  }) {
    return Product(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      storeUrl: storeUrl ?? this.storeUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isTrending: isTrending ?? this.isTrending,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json, {String brandName = ''}) {
    final price = (json['price_inr'] as num?)?.toDouble() ?? 0.0;
    return Product(
      id: json['id'] as String? ?? '',
      brandId: json['brand_id'] as String? ?? '',
      brandName: brandName.isNotEmpty ? brandName : (json['brand_name'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      originalPrice: price,
      discountPrice: price > 0 ? (price * 0.85).roundToDouble() : 0.0,
      storeUrl: json['target_url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      isTrending: json['badge_text'] != null && (json['badge_text'] as String).isNotEmpty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId,
      'brand_name': brandName,
      'title': title,
      'description': description,
      'price_inr': originalPrice,
      'target_url': storeUrl,
      'image_url': imageUrl,
      'badge_text': isTrending ? 'Trending' : '',
    };
  }
}

