import 'package:bokrah/app/config/routes.dart';
import 'package:bokrah/app/config/theme.dart';
import 'package:bokrah/app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_state.dart';
import 'package:bokrah/app/config/l10n/app_localizations.dart';
import 'package:bokrah/app/initialzation_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        return MaterialApp.router(
          debugShowMaterialGrid: false,
          title: packageInfo.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppTheme.deepOrange,
              primary: AppTheme.deepOrange,
              surface: AppTheme.creamBackground,
            ),
            scaffoldBackgroundColor: AppTheme.creamBackground,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppTheme.deepOrange,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
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
