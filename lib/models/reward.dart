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
}
