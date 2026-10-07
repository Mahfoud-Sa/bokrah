// ==============================================================================
// DEVELOPMENT MOCK AUTHENTICATION SERVICE
// ------------------------------------------------------------------------------
// WARNING: This is a simulated mock implementation for local development and
// UI testing only. It does NOT connect to a real SMS gateway or identity provider.
//
// DO NOT DEPLOY THIS TO PRODUCTION.
// In production, implement AuthService using your actual REST or GraphQL backend
// (e.g. Firebase Auth, Twilio Verify, or custom restaurant backend server).
// ==============================================================================
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import '../datasources/auth_token_storage.dart';
import '../models/auth_session_model.dart';
import '../models/otp_response_model.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  final AuthTokenStorage _tokenStorage;
  final Duration _simulatedLatency;

  // Active in-memory verification sessions for mock simulation
  final Map<String, _MockVerificationSession> _activeSessions = {};
  final Map<String, int> _resendCounters = {};

  MockAuthService({
    required AuthTokenStorage tokenStorage,
    Duration simulatedLatency = const Duration(milliseconds: 700),
  })  : _tokenStorage = tokenStorage,
        _simulatedLatency = simulatedLatency;

  @override
  Future<AuthSessionModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_simulatedLatency);

    final cleanEmail = email.trim().toLowerCase();
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(cleanEmail) ||
        password.length < 6) {
      throw const AuthException(
        code: AuthErrorCode.invalidCredentials,
        message: 'Invalid email or password.',
      );
    }

    if (password == 'wrongpass' || cleanEmail == 'wrong@bokrah.com') {
      throw const AuthException(
        code: AuthErrorCode.invalidCredentials,
        message: 'Invalid email or password.',
      );
    }

    final session = AuthSessionModel(
      userId: 'user_${cleanEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      phoneNumber: '',
      accessToken: 'mock_jwt_email_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_jwt_refresh_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await _tokenStorage.saveSession(session);
    return session;
  }

  @override
  Future<AuthSessionModel> loginWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(_simulatedLatency);

    if (password.length < 6) {
      throw const AuthException(
        code: AuthErrorCode.invalidCredentials,
        message: 'Password must be at least 6 characters.',
      );
    }

    if (password == 'wrongpass' || phoneNumber.endsWith('0000')) {
      throw const AuthException(
        code: AuthErrorCode.invalidCredentials,
        message: 'Invalid phone number or password.',
      );
    }

    if (phoneNumber.endsWith('9999')) {
      throw const AuthException(
        code: AuthErrorCode.rateLimited,
        message: 'Too many attempts. Please try again later.',
      );
    }

    final session = AuthSessionModel(
      userId: 'user_${phoneNumber.replaceAll('+', '')}',
      phoneNumber: phoneNumber,
      accessToken: 'mock_jwt_phone_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_jwt_refresh_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await _tokenStorage.saveSession(session);
    return session;
  }

  @override
  Future<SendOtpResponse> sendOtp({required String phoneNumber}) async {
    await Future.delayed(_simulatedLatency);

    // Rate-limit test simulation: numbers ending with 9999 trigger rate limit
    if (phoneNumber.endsWith('9999')) {
      throw AuthException(
        code: AuthErrorCode.rateLimited,
        message: 'Rate limit exceeded for this number. Please wait.',
      );
    }

    final verificationId = 'mock_verif_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    const codeLength = 6;
    const cooldownSeconds = 60;

    _activeSessions[verificationId] = _MockVerificationSession(
      phoneNumber: phoneNumber,
      expectedCode: '123456', // Default mock acceptance code (any 6 digits valid except test triggers)
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      codeLength: codeLength,
    );

    _resendCounters[phoneNumber] = (_resendCounters[phoneNumber] ?? 0) + 1;

    return SendOtpResponse(
      verificationId: verificationId,
      codeLength: codeLength,
      resendCooldownSeconds: cooldownSeconds,
      normalizedPhone: phoneNumber,
      message: 'Verification code dispatched to $phoneNumber (Mock code: 123456)',
    );
  }

  @override
  Future<VerifyOtpResponse> verifyOtp({
    required String verificationId,
    required String phoneNumber,
    required String otpCode,
  }) async {
    await Future.delayed(_simulatedLatency);

    // Test Trigger: '000000' triggers invalid code error
    if (otpCode == '000000') {
      return VerifyOtpResponse.failure(
        AuthErrorCode.invalidOtp,
        'Invalid verification code. Please check and try again.',
      );
    }

    // Test Trigger: '111111' triggers expired code error
    if (otpCode == '111111') {
      return VerifyOtpResponse.failure(
        AuthErrorCode.expiredOtp,
        'Verification code has expired. Please request a new one.',
      );
    }

    final session = _activeSessions[verificationId];
    if (session == null || DateTime.now().isAfter(session.expiresAt)) {
      return VerifyOtpResponse.failure(
        AuthErrorCode.expiredOtp,
        'Verification session expired. Please request a new code.',
      );
    }

    // Must be numeric and match length
    if (otpCode.length != session.codeLength || !RegExp(r'^\d+$').hasMatch(otpCode)) {
      return VerifyOtpResponse.failure(
        AuthErrorCode.invalidOtp,
        'Code must be ${session.codeLength} digits.',
      );
    }

    // Generate authenticated session
    final authSession = AuthSessionModel(
      userId: 'user_${phoneNumber.replaceAll('+', '')}',
      phoneNumber: phoneNumber,
      accessToken: 'mock_jwt_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_jwt_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    // Save session in persistent storage
    await _tokenStorage.saveSession(authSession);

    // Clean up active session
    _activeSessions.remove(verificationId);
    _resendCounters.remove(phoneNumber);

    return VerifyOtpResponse.success(authSession);
  }

  @override
  Future<SendOtpResponse> resendOtp({
    required String verificationId,
    required String phoneNumber,
  }) async {
    await Future.delayed(_simulatedLatency);

    final currentAttempts = _resendCounters[phoneNumber] ?? 0;
    if (currentAttempts >= 5) {
      throw AuthException(
        code: AuthErrorCode.rateLimited,
        message: 'Too many OTP requests. Please wait a few minutes.',
      );
    }

    return sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<void> signOut() async {
    await _tokenStorage.clearSession();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _tokenStorage.hasValidSession();
  }

  @override
  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }
}

class AuthException implements Exception {
  final AuthErrorCode code;
  final String message;

  const AuthException({required this.code, required this.message});

  @override
  String toString() => 'AuthException($code): $message';
}

class _MockVerificationSession {
  final String phoneNumber;
  final String expectedCode;
  final DateTime expiresAt;
  final int codeLength;

  _MockVerificationSession({
    required this.phoneNumber,
    required this.expectedCode,
    required this.expiresAt,
    required this.codeLength,
  });
}
