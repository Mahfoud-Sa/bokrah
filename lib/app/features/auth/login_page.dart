import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../initialzation_dependencies.dart';
import 'data/datasources/auth_token_storage.dart';
import 'data/services/auth_service.dart';
import 'data/services/mock_auth_service.dart';
import 'presentation/cubits/auth_cubit.dart';
import 'presentation/cubits/auth_state.dart';
import 'presentation/pages/otp_verification_view.dart';
import 'presentation/pages/phone_input_view.dart';

class LoginPage extends StatelessWidget {
  final AuthService? authService;

  const LoginPage({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthService>(
      future: _resolveAuthService(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppTheme.creamBackground,
            body: Center(
              child: CircularProgressIndicator(
                color: AppTheme.deepOrange,
              ),
            ),
          );
        }

        return BlocProvider(
          create: (_) => AuthCubit(authService: snapshot.data!),
          child: const _LoginPageContent(),
        );
      },
    );
  }

  Future<AuthService> _resolveAuthService() async {
    if (authService != null) return authService!;
    if (singelton.isRegistered<AuthService>()) {
      return singelton<AuthService>();
    }
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPrefsAuthTokenStorage(prefs: prefs);
    final mockService = MockAuthService(tokenStorage: storage);
    singelton.registerSingleton<AuthTokenStorage>(storage);
    singelton.registerSingleton<AuthService>(mockService);
    return mockService;
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AuthStatus.authenticated,
      listener: (context, state) {
        // Navigate to the home screen after successful authentication
        try {
          context.go('/home');
        } catch (_) {
          // Fallback when executed outside GoRouter harness
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.creamBackground,
        body: SafeArea(
          child: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) => previous.step != current.step,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, animation) {
                  final inFromRight = Tween<Offset>(
                    begin: const Offset(0.08, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: inFromRight,
                      child: child,
                    ),
                  );
                },
                child: state.step == AuthStep.login
                    ? const KeyedSubtree(
                        key: ValueKey('phone_input_view'),
                        child: PhoneInputView(),
                      )
                    : const KeyedSubtree(
                        key: ValueKey('otp_verification_view'),
                        child: OtpVerificationView(),
                      )
              );
            },
          ),
        ),
      ),
    );
  }
}
