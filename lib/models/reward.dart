enum RewardType { voucher, physicalProduct }

class Reward {
  final String id;
  final String brandId;
  final String brandName;
  final String title;
  final String description;
  final RewardType type;
  final String? promoCode;
  final String? discountValue;
  final DateTime expiryDate;
  final bool isClaimed;
  final String? shippingAddress;
  final String? trackingNumber;
  final String? deliveryStatus;

  const Reward({
    required this.id,
    required this.brandId,
    required this.brandName,
    required this.title,
    required this.description,
    required this.type,
    this.promoCode,
    this.discountValue,
    required this.expiryDate,
    this.isClaimed = false,
    this.shippingAddress,
    this.trackingNumber,
    this.deliveryStatus,
  });

  Reward copyWith({
    String? id,
    String? brandId,
    String? brandName,
    String? title,
    String? description,
    RewardType? type,
    String? promoCode,
    String? discountValue,
    DateTime? expiryDate,
    bool? isClaimed,
    String? shippingAddress,
    String? trackingNumber,
    String? deliveryStatus,
  }) {
    return Reward(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      promoCode: promoCode ?? this.promoCode,
      discountValue: discountValue ?? this.discountValue,
      expiryDate: expiryDate ?? this.expiryDate,
      isClaimed: isClaimed ?? this.isClaimed,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  factory Reward.fromJson(Map<String, dynamic> json, {String brandName = ''}) {
    final typeStr = (json['type'] as String? ?? 'voucher').toLowerCase();
    final type = typeStr == 'physical_product' || typeStr == 'physicalproduct'
        ? RewardType.physicalProduct
        : RewardType.voucher;

    DateTime expiry;
    if (json['valid_until'] != null) {
      expiry = DateTime.tryParse(json['valid_until'] as String) ??
          DateTime.now().add(const Duration(days: 30));
    } else if (json['expiry_date'] != null) {
      expiry = DateTime.tryParse(json['expiry_date'] as String) ??
          DateTime.now().add(const Duration(days: 30));
    } else {
      expiry = DateTime.now().add(const Duration(days: 30));
    }

    return Reward(
      id: json['id'] as String? ?? '',
      brandId: json['brand_id'] as String? ?? '',
      brandName: brandName.isNotEmpty ? brandName : (json['brand_name'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: type,
      promoCode: json['promo_code'] as String?,
      discountValue: json['discount_text'] as String? ?? json['discount_value'] as String?,
      expiryDate: expiry,
      isClaimed: json['status'] == 'claimed' || json['is_claimed'] == true,
      shippingAddress: json['shipping_address'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      deliveryStatus: json['delivery_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId,
      'brand_name': brandName,
      'title': title,
      'description': description,
      'type': type == RewardType.physicalProduct ? 'physical_product' : 'voucher',
      'promo_code': promoCode,
      'discount_text': discountValue,
      'valid_until': expiryDate.toIso8601String(),
      'status': isClaimed ? 'claimed' : 'available',
      'shipping_address': shippingAddress,
      'tracking_number': trackingNumber,
      'delivery_status': deliveryStatus,
    };
  }
}

