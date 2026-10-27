import 'package:bokrah/app/config/routes.dart';
import 'package:bokrah/app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_state.dart';
import 'package:bokrah/app/config/l10n/app_localizations.dart';
import 'package:bokrah/app/initialzation_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/cubits/app_update_cubit.dart';
import 'package:bokrah/app/features/users/presentation/cubits/session_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bokrah_design_system/bokrah_design_system.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializationDependencies();
  final prefs = await SharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(
            localDataSource: SettingsLocalDataSource(sharedPreferences: prefs),
          ),
        ),
        BlocProvider(
          create: (context) => singelton<AppUpdateCubit>(),
        ),
        BlocProvider(
          create: (context) => singelton<SessionCubit>(),
        ),
      ],
      child: MyApp(packageInfo: packageInfo),
    ),
  );
}

class MyApp extends StatelessWidget {
  final PackageInfo packageInfo;

  const MyApp({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';
        final light = state.isHighContrast
            ? BkTheme.highContrast(arabic: isArabic)
            : BkTheme.light(arabic: isArabic);
        final dark = state.isHighContrast
            ? BkTheme.highContrast(arabic: isArabic)
            : BkTheme.dark(arabic: isArabic);

        return MaterialApp.router(
          debugShowMaterialGrid: false,
          title: packageInfo.appName,
          theme: light,
          darkTheme: dark,
          highContrastTheme: BkTheme.highContrast(arabic: isArabic),
          highContrastDarkTheme: BkTheme.highContrast(arabic: isArabic),
          themeMode: state.themeMode,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRoutes.routers,
        );
      },
    );
  }
}
