// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/l10n/app_localizations.dart';
import '../../../../config/theme.dart';
import '../../../settings/presentation/cubits/settings_cubit.dart';

class RestaurantHeader extends StatelessWidget {
  const RestaurantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Language Switcher Bar
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<SettingsCubit>().toggleLanguage();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.creamInputFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.borderWarm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.language,
                        size: 16,
                        color: AppTheme.deepOrange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'English' : 'العربية',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDarkBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Hero Food & Logo Banner
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Food Image Hero Container
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.shadowWarm,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/food_banner.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD84315),
                                Color(0xFFE65100),
                                Color(0xFFFF8F00),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay to provide rich warm tone
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Overlapping Restaurant Logo Badge
            Positioned(
              bottom: -32,
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.creamSurface,
                  border: Border.all(
                    color: AppTheme.deepOrange,
                    width: 2.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.shadowWarm,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/restaurant_logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E1714),
                        child: const Icon(
                          Icons.restaurant,
                          color: Color(0xFFFFB300),
                          size: 36,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 44),

        // Welcome Heading
        Text(
          l10n.welcomeHeading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDarkBrown,
            letterSpacing: -0.3,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 8),

        // Supporting Text
        Text(
          l10n.welcomeSupporting,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.textMediumBrown,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
