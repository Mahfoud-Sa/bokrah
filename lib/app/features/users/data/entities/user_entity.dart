class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final List<String> roles;
  final String? profileImage;
  final bool isActive;
  final String? createdAt;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.gender,
    this.roles = const ['Staff'],
    this.profileImage,
    this.isActive = true,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
      'roles': roles,
      'profileImage': profileImage,
      'isActive': isActive,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      roles: List<String>.from(map['roles'] ?? ['Staff']),
      profileImage: map['profileImage'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'],
    );
  }
}
