import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/country_code_model.dart';
import '../../data/models/otp_response_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/mock_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  Timer? _countdownTimer;

  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(AuthState.initial());

  void setLoginMethod(LoginMethod method) {
    emit(state.copyWith(
      loginMethod: method,
      clearError: true,
    ));
  }

  void setEmail(String email) {
    emit(state.copyWith(
      email: email,
      clearError: true,
    ));
  }

  void setPassword(String password) {
    emit(state.copyWith(
      password: password,
      clearError: true,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    ));
  }

  void setCountry(CountryCodeModel country) {
    emit(state.copyWith(
      selectedCountry: country,
      clearError: true,
    ));
  }

  void setPhoneNumber(String phone) {
    emit(state.copyWith(
      rawPhoneNumber: phone,
      clearError: true,
    ));
  }

  void setOtpCode(String otp) {
    emit(state.copyWith(
      otpCode: otp,
      clearError: true,
    ));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void editPhoneNumber() {
    _countdownTimer?.cancel();
    emit(state.copyWith(
      step: AuthStep.login,
      status: AuthStatus.idle,
      otpCode: '',
      clearError: true,
    ));
  }

  /// Sign in using either Email + Password OR Phone Number + Password.
  /// Prevents duplicate concurrent requests.
  Future<void> submitLogin() async {
    if (state.isSubmitting) return;

    if (state.loginMethod == LoginMethod.email) {
      if (!state.isEmailValid || !state.isPasswordValid) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: AuthErrorCode.invalidCredentials,
          errorMessage: 'Invalid email or password format',
        ));
        return;
      }

      emit(state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ));

      try {
        await _authService.loginWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password,
        );

        emit(state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        ));
      } on AuthException catch (e) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: e.code,
          errorMessage: e.message,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: AuthErrorCode.unknown,
          errorMessage: e.toString(),
        ));
      }
    } else {
      // Phone + Password
      if (!state.isPhoneValid || !state.isPasswordValid) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: AuthErrorCode.invalidCredentials,
          errorMessage: 'Invalid phone number or password format',
        ));
        return;
      }

      final normalized =
          state.selectedCountry.normalize(state.rawPhoneNumber);

      emit(state.copyWith(
        status: AuthStatus.loading,
        normalizedPhoneNumber: normalized,
        clearError: true,
      ));

      try {
        await _authService.loginWithPhoneAndPassword(
          phoneNumber: normalized,
          password: state.password,
        );

        emit(state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        ));
      } on AuthException catch (e) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: e.code,
          errorMessage: e.message,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: AuthErrorCode.unknown,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  /// Initiates sending OTP code to the normalized phone number.
  Future<void> sendOtp() async {
    if (state.isSubmitting) return;

    if (!state.isPhoneValid) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.invalidOtp,
        errorMessage: 'Invalid phone number format',
      ));
      return;
    }

    final normalized =
        state.selectedCountry.normalize(state.rawPhoneNumber);

    emit(state.copyWith(
      status: AuthStatus.sendingOtp,
      normalizedPhoneNumber: normalized,
      clearError: true,
    ));

    try {
      final response = await _authService.sendOtp(phoneNumber: normalized);

      emit(state.copyWith(
        step: AuthStep.otpVerification,
        status: AuthStatus.otpSent,
        verificationId: response.verificationId,
        codeLength: response.codeLength,
        resendCountdown: response.resendCooldownSeconds,
        otpCode: '',
        clearError: true,
      ));

      _startResendCountdown(response.resendCooldownSeconds);
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: e.code,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.unknown,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Resends OTP to the current phone number if cooldown has elapsed.
  Future<void> resendOtp() async {
    if (state.isSubmitting || !state.canResend) return;
    if (state.normalizedPhoneNumber == null || state.verificationId == null) return;

    emit(state.copyWith(
      status: AuthStatus.sendingOtp,
      clearError: true,
    ));

    try {
      final response = await _authService.resendOtp(
        verificationId: state.verificationId!,
        phoneNumber: state.normalizedPhoneNumber!,
      );

      emit(state.copyWith(
        status: AuthStatus.otpSent,
        verificationId: response.verificationId,
        codeLength: response.codeLength,
        resendCountdown: response.resendCooldownSeconds,
        clearError: true,
      ));

      _startResendCountdown(response.resendCooldownSeconds);
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: e.code,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.unknown,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Verifies OTP submitted by user.
  Future<void> verifyOtp() async {
    if (state.isSubmitting) return;

    if (state.otpCode.length != state.codeLength) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.invalidOtp,
        errorMessage: 'Incomplete OTP code',
      ));
      return;
    }

    if (state.verificationId == null || state.normalizedPhoneNumber == null) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.expiredOtp,
        errorMessage: 'Session expired. Please request a new code.',
      ));
      return;
    }

    emit(state.copyWith(
      status: AuthStatus.verifyingOtp,
      clearError: true,
    ));

    try {
      final result = await _authService.verifyOtp(
        verificationId: state.verificationId!,
        phoneNumber: state.normalizedPhoneNumber!,
        otpCode: state.otpCode,
      );

      if (result.isSuccess) {
        _countdownTimer?.cancel();
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorCode: result.errorCode ?? AuthErrorCode.invalidOtp,
          errorMessage: result.errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorCode: AuthErrorCode.unknown,
        errorMessage: e.toString(),
      ));
    }
  }

  void _startResendCountdown(int seconds) {
    _countdownTimer?.cancel();
    emit(state.copyWith(resendCountdown: seconds));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.resendCountdown;
      if (current <= 1) {
        timer.cancel();
        emit(state.copyWith(resendCountdown: 0));
      } else {
        emit(state.copyWith(resendCountdown: current - 1));
      }
    });
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
