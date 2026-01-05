class ItemEntity {
  final int? id;
  final String name;
  final double sellPrice;
  final double purchasePrice;
  final int quantity;
  final String? qrCode;
  final String? description;
  final int? categoryId; // Added categoryId
  final DateTime createdAt;

  ItemEntity({
    this.id,
    required this.name,
    required this.sellPrice,
    required this.purchasePrice,
    required this.quantity,
    this.qrCode,
    this.description,
    this.categoryId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sellPrice': sellPrice,
      'purchasePrice': purchasePrice,
      'quantity': quantity,
      'qrCode': qrCode,
      'description': description,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    return ItemEntity(
      id: map['id'],
      name: map['name'],
      sellPrice:
          map['sellPrice']?.toDouble() ??
          map['price']?.toDouble() ??
          0.0, // backward compatibility
      purchasePrice: map['purchasePrice']?.toDouble() ?? 0.0,
      quantity: map['quantity'],
      qrCode: map['qrCode'],
      description: map['description'],
      categoryId: map['categoryId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Calculate profit margin
  double get profitMargin => sellPrice - purchasePrice;

  // Calculate profit percentage
  double get profitPercentage => purchasePrice > 0
      ? ((sellPrice - purchasePrice) / purchasePrice) * 100
      : 0.0;
}
