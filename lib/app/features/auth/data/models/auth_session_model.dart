import 'dart:convert';

/// Represents an authenticated user session with tokens and user info.
class AuthSessionModel {
  final String userId;
  final String phoneNumber;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthSessionModel({
    required this.userId,
    required this.phoneNumber,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AuthSessionModel.fromMap(Map<String, dynamic> map) {
    return AuthSessionModel(
      userId: map['userId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresAt: DateTime.parse(map['expiresAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthSessionModel.fromJson(String source) =>
      AuthSessionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
