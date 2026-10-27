import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String slogan;
  final String cuisineType;
  final String? logo;
  final String? cover;

  // Legal & Tax
  final String commercialRegistration;
  final String taxNumber;
  final double taxRate;
  final bool isTaxEnabled;
  final String currency;

  // Contact
  final String phoneNumber;
  final String mobileNumber;
  final String email;
  final String website;

  // Address
  final String country;
  final String city;
  final String district;
  final String street;
  final String buildingNumber;
  final String postalCode;
  final String shortAddress;

  // Operations & Receipt Settings
  final String receiptHeaderNote;
  final String receiptFooterNote;
  final double serviceChargeRate;
  final String openingTime;
  final String closingTime;
  final String? updatedAt;

  const RestaurantEntity({
    this.id = 'default_restaurant',
    required this.nameAr,
    required this.nameEn,
    this.slogan = 'نكهات أصيلة وتجربة استثنائية',
    this.cuisineType = 'مشويات ومأكولات شرقية',
    this.logo,
    this.cover,
    this.commercialRegistration = '1010123456',
    this.taxNumber = '310123456700003',
    this.taxRate = 15.0,
    this.isTaxEnabled = true,
    this.currency = 'SAR',
    this.phoneNumber = '920000000',
    this.mobileNumber = '+966501234567',
    this.email = 'info@bokrah-restaurant.com',
    this.website = 'https://bokrah.com',
    this.country = 'المملكة العربية السعودية',
    this.city = 'الرياض',
    this.district = 'حي العليا',
    this.street = 'طريق الملك فهد',
    this.buildingNumber = '124',
    this.postalCode = '12214',
    this.shortAddress = 'RRRD2345',
    this.receiptHeaderNote = 'أهلاً بكم في مطعم بكرة، نأمل لكم تجربة ممتعة',
    this.receiptFooterNote = 'شكراً لزيارتكم! الفاتورة الضريبية المبسطة',
    this.serviceChargeRate = 0.0,
    this.openingTime = '08:00 ص',
    this.closingTime = '12:00 م',
    this.updatedAt,
  });

  /// Default demo restaurant data for immediate rich display
  factory RestaurantEntity.defaultRestaurant() {
    return const RestaurantEntity(
      nameAr: 'مطعم بكرة',
      nameEn: 'Bokrah Restaurant',
      slogan: 'نكهات أصيلة وضيافة راقية',
      cuisineType: 'مأكولات شرقية وعالمية',
      commercialRegistration: '1010543210',
      taxNumber: '310987654300003',
      taxRate: 15.0,
      isTaxEnabled: true,
      currency: 'SAR',
      phoneNumber: '0112345678',
      mobileNumber: '+966551234567',
      email: 'contact@bokrah.com',
      website: 'https://bokrah.restaurant',
      country: 'المملكة العربية السعودية',
      city: 'الرياض',
      district: 'حي النخيل',
      street: 'شارع الأمير تركي الأول',
      buildingNumber: '45',
      postalCode: '12381',
      shortAddress: 'RYAD1234',
      receiptHeaderNote: 'أهلاً بكم في مطعم بكرة - نسعد بخدمتكم',
      receiptFooterNote: 'شكراً لزيارتكم، نتطلع لرؤيتكم قريباً!',
      serviceChargeRate: 0.0,
      openingTime: '09:00 ص',
      closingTime: '01:00 ص',
    );
  }

  String get fullAddress {
    final parts = [country, city, district, street, buildingNumber]
        .where((p) => p.isNotEmpty)
        .toList();
    return parts.join(' - ');
  }

  RestaurantEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? slogan,
    String? cuisineType,
    String? logo,
    String? cover,
    String? commercialRegistration,
    String? taxNumber,
    double? taxRate,
    bool? isTaxEnabled,
    String? currency,
    String? phoneNumber,
    String? mobileNumber,
    String? email,
    String? website,
    String? country,
    String? city,
    String? district,
    String? street,
    String? buildingNumber,
    String? postalCode,
    String? shortAddress,
    String? receiptHeaderNote,
    String? receiptFooterNote,
    double? serviceChargeRate,
    String? openingTime,
    String? closingTime,
    String? updatedAt,
  }) {
    return RestaurantEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      slogan: slogan ?? this.slogan,
      cuisineType: cuisineType ?? this.cuisineType,
      logo: logo ?? this.logo,
      cover: cover ?? this.cover,
      commercialRegistration:
          commercialRegistration ?? this.commercialRegistration,
      taxNumber: taxNumber ?? this.taxNumber,
      taxRate: taxRate ?? this.taxRate,
      isTaxEnabled: isTaxEnabled ?? this.isTaxEnabled,
      currency: currency ?? this.currency,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      country: country ?? this.country,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      postalCode: postalCode ?? this.postalCode,
      shortAddress: shortAddress ?? this.shortAddress,
      receiptHeaderNote: receiptHeaderNote ?? this.receiptHeaderNote,
      receiptFooterNote: receiptFooterNote ?? this.receiptFooterNote,
      serviceChargeRate: serviceChargeRate ?? this.serviceChargeRate,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'slogan': slogan,
      'cuisineType': cuisineType,
      'logo': logo,
      'cover': cover,
      'commercialRegistration': commercialRegistration,
      'taxNumber': taxNumber,
      'taxRate': taxRate,
      'isTaxEnabled': isTaxEnabled,
      'currency': currency,
      'phoneNumber': phoneNumber,
      'mobileNumber': mobileNumber,
      'email': email,
      'website': website,
      'country': country,
      'city': city,
      'district': district,
      'street': street,
      'buildingNumber': buildingNumber,
      'postalCode': postalCode,
      'shortAddress': shortAddress,
      'receiptHeaderNote': receiptHeaderNote,
      'receiptFooterNote': receiptFooterNote,
      'serviceChargeRate': serviceChargeRate,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'updatedAt': updatedAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory RestaurantEntity.fromMap(Map<String, dynamic> map) {
    return RestaurantEntity(
      id: map['id'] ?? 'default_restaurant',
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      slogan: map['slogan'] ?? '',
      cuisineType: map['cuisineType'] ?? '',
      logo: map['logo'],
      cover: map['cover'],
      commercialRegistration: map['commercialRegistration'] ?? '',
      taxNumber: map['taxNumber'] ?? '',
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 15.0,
      isTaxEnabled: map['isTaxEnabled'] ?? true,
      currency: map['currency'] ?? 'SAR',
      phoneNumber: map['phoneNumber'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      street: map['street'] ?? '',
      buildingNumber: map['buildingNumber'] ?? '',
      postalCode: map['postalCode'] ?? '',
      shortAddress: map['shortAddress'] ?? '',
      receiptHeaderNote: map['receiptHeaderNote'] ?? '',
      receiptFooterNote: map['receiptFooterNote'] ?? '',
      serviceChargeRate: (map['serviceChargeRate'] as num?)?.toDouble() ?? 0.0,
      openingTime: map['openingTime'] ?? '08:00 ص',
      closingTime: map['closingTime'] ?? '12:00 م',
      updatedAt: map['updatedAt'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        slogan,
        cuisineType,
        logo,
        cover,
        commercialRegistration,
        taxNumber,
        taxRate,
        isTaxEnabled,
        currency,
        phoneNumber,
        mobileNumber,
        email,
        website,
        country,
        city,
        district,
        street,
        buildingNumber,
        postalCode,
        shortAddress,
        receiptHeaderNote,
        receiptFooterNote,
        serviceChargeRate,
        openingTime,
        closingTime,
        updatedAt,
      ];
}
