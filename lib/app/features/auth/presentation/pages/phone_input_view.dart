import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/l10n/app_localizations.dart';
import '../../../../config/theme.dart';
import '../../data/models/country_code_model.dart';
import '../../data/models/otp_response_model.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/country_code_picker_dialog.dart';
import '../widgets/restaurant_header.dart';
import '../widgets/terms_dialog.dart';

class PhoneInputView extends StatefulWidget {
  const PhoneInputView({super.key});

  @override
  State<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<PhoneInputView> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuthCubit>();
    _emailController = TextEditingController(text: cubit.state.email);
    _phoneController = TextEditingController(text: cubit.state.rawPhoneNumber);
    _passwordController = TextEditingController(text: cubit.state.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openCountryPicker(CountryCodeModel current) async {
    final selected = await CountryCodePickerDialog.show(
      context,
      selectedCountry: current,
    );
    if (selected != null && mounted) {
      context.read<AuthCubit>().setCountry(selected);
    }
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creamSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        title: Row(
          children: [
            const Icon(Icons.lock_reset, color: AppTheme.deepOrange, size: 26),
            const SizedBox(width: 10),
            Text(
              l10n.forgotPassword,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDarkBrown,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.forgotPasswordNotice,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textMediumBrown,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(foregroundColor: AppTheme.deepOrange),
            child: Text(
              l10n.close,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveErrorMessage(BuildContext context, AuthState state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state.errorCode) {
      case AuthErrorCode.invalidCredentials:
        return l10n.invalidCredentialsError;
      case AuthErrorCode.rateLimited:
        return l10n.rateLimitError;
      case AuthErrorCode.networkError:
        return l10n.networkError;
      default:
        return state.errorMessage ?? l10n.invalidCredentialsError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_emailController.text != state.email) {
          _emailController.text = state.email;
        }
        if (_phoneController.text != state.rawPhoneNumber) {
          _phoneController.text = state.rawPhoneNumber;
        }
        if (_passwordController.text != state.password) {
          _passwordController.text = state.password;
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        final hasError =
            state.errorMessage != null && state.errorMessage!.isNotEmpty;
        final isEmailMode = state.loginMethod == LoginMethod.email;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Restaurant Header (Banner, Logo, Title, Subtitle, Language Switcher)
                  const RestaurantHeader(),

                  const SizedBox(height: 28),

                  // Method Toggle Tabs: Email & Password vs Phone & Password
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.creamInputFill,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderWarm),
                    ),
                    child: Row(
                      children: [
                        // Email Tab
                        Expanded(
                          child: InkWell(
                            onTap: state.isSubmitting
                                ? null
                                : () => cubit.setLoginMethod(LoginMethod.email),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isEmailMode
                                    ? AppTheme.creamSurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isEmailMode
                                    ? const [
                                        BoxShadow(
                                          color: AppTheme.shadowWarm,
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                    color: isEmailMode
                                        ? AppTheme.deepOrange
                                        : AppTheme.textMediumBrown,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      l10n.signInWithEmail,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isEmailMode
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isEmailMode
                                            ? AppTheme.deepOrange
                                            : AppTheme.textMediumBrown,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Phone Tab
                        Expanded(
                          child: InkWell(
                            onTap: state.isSubmitting
                                ? null
                                : () => cubit.setLoginMethod(LoginMethod.phone),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isEmailMode
                                    ? AppTheme.creamSurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: !isEmailMode
                                    ? const [
                                        BoxShadow(
                                          color: AppTheme.shadowWarm,
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone_iphone_outlined,
                                    size: 18,
                                    color: !isEmailMode
                                        ? AppTheme.deepOrange
                                        : AppTheme.textMediumBrown,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      l10n.signInWithPhone,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: !isEmailMode
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: !isEmailMode
                                            ? AppTheme.deepOrange
                                            : AppTheme.textMediumBrown,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Credentials Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.creamSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                      border: Border.all(
                        color:
                            hasError ? AppTheme.errorRed : AppTheme.borderWarm,
                        width: hasError ? 1.5 : 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.shadowWarm,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEmailMode) ...[
                          // Email Field Label
                          Text(
                            l10n.email,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDarkBrown,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Email Input
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.creamInputFill,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusInput),
                              border: Border.all(color: AppTheme.borderWarm),
                            ),
                            child: TextField(
                              controller: _emailController,
                              enabled: !state.isSubmitting,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDarkBrown,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppTheme.textMediumBrown,
                                ),
                                hintText: l10n.emailHint,
                                hintStyle: const TextStyle(
                                  color: AppTheme.textMutedBrown,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: (val) => cubit.setEmail(val),
                            ),
                          ),
                        ] else ...[
                          // Phone Field Label
                          Text(
                            l10n.phoneNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDarkBrown,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Combined Country Code + Phone Input
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.creamInputFill,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusInput),
                              border: Border.all(color: AppTheme.borderWarm),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: state.isSubmitting
                                      ? null
                                      : () => _openCountryPicker(
                                            state.selectedCountry,
                                          ),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(AppTheme.radiusInput),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          state.selectedCountry.flagEmoji,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 6),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            state.selectedCountry.dialCode,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.textDarkBrown,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: AppTheme.textMediumBrown,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: AppTheme.borderWarm,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    enabled: !state.isSubmitting,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                        state.selectedCountry.maxLength + 1,
                                      ),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDarkBrown,
                                      letterSpacing: 0.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          state.selectedCountry.placeholder,
                                      hintStyle: const TextStyle(
                                        color: AppTheme.textMutedBrown,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 14,
                                      ),
                                    ),
                                    onChanged: (val) =>
                                        cubit.setPhoneNumber(val),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Password Field Label
                        Text(
                          l10n.password,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDarkBrown,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Password Input
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.creamInputFill,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusInput),
                            border: Border.all(color: AppTheme.borderWarm),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            enabled: !state.isSubmitting,
                            obscureText: !state.isPasswordVisible,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDarkBrown,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppTheme.textMediumBrown,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppTheme.textMediumBrown,
                                ),
                                onPressed: () =>
                                    cubit.togglePasswordVisibility(),
                              ),
                              hintText: l10n.passwordHint,
                              hintStyle: const TextStyle(
                                color: AppTheme.textMutedBrown,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (val) => cubit.setPassword(val),
                            onSubmitted: (_) {
                              if (state.canSubmitLogin) {
                                cubit.submitLogin();
                              }
                            },
                          ),
                        ),

                        // Forgot Password Link
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.textMediumBrown,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                            child: Text(
                              l10n.forgotPassword,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Error message feedback
                        if (hasError) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.errorRed,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _resolveErrorMessage(context, state),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.errorRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Primary Button
                  AuthButton(
                    text: l10n.signIn,
                    icon: Icons.login_rounded,
                    isLoading: state.isSubmitting,
                    onPressed: state.canSubmitLogin
                        ? () {
                            FocusScope.of(context).unfocus();
                            cubit.submitLogin();
                          }
                        : null,
                  ),

                  const SizedBox(height: 20),

                  // Terms of Service and Privacy Policy Link
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMediumBrown,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(text: l10n.termsAndPrivacyPrefix),
                          TextSpan(
                            text: l10n.termsOfService,
                            style: const TextStyle(
                              color: AppTheme.deepOrange,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => TermsDialog.show(
                                    context,
                                    isPrivacy: false,
                                  ),
                          ),
                          TextSpan(text: l10n.and),
                          TextSpan(
                            text: l10n.privacyPolicy,
                            style: const TextStyle(
                              color: AppTheme.deepOrange,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => TermsDialog.show(
                                    context,
                                    isPrivacy: true,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Development Demo Note
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.creamInputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderWarm),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppTheme.deepOrange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.demoCredentialsNote,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMediumBrown,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
