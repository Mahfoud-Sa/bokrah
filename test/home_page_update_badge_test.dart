import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bokrah/app/features/autoUpdate/domain/entities/app_release.dart';
import 'package:bokrah/app/features/autoUpdate/domain/repositories/app_update_repository.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/cubits/app_update_cubit.dart';
import 'package:bokrah/app/config/l10n/app_localizations.dart';
import 'package:bokrah/app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:bokrah/app/features/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StubAppUpdateRepository implements AppUpdateRepository {
  AppRelease? latestRelease;
  bool isAvailable = false;
  bool isSkipped = false;

  @override
  Future<AppRelease?> getLatestRelease() async => latestRelease;

  @override
  Future<String> getInstalledVersion() async => '3.3.0';

  @override
  bool isUpdateAvailable(String installedVersion, String latestVersion) => isAvailable;

  @override
  Future<bool> isVersionSkipped(String version) async => isSkipped;

  @override
  Future<void> skipVersion(String version) async {}

  @override
  Future<bool> launchDownloadUrl(String url) async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StubAppUpdateRepository repository;
  late AppUpdateCubit updateCubit;
  late SettingsCubit settingsCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    repository = StubAppUpdateRepository();
    updateCubit = AppUpdateCubit(repository: repository);
    settingsCubit = SettingsCubit(
      localDataSource: SettingsLocalDataSource(sharedPreferences: prefs),
    );
  });

  tearDown(() {
    updateCubit.close();
    settingsCubit.close();
  });

  Widget buildTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: settingsCubit),
        BlocProvider<AppUpdateCubit>.value(value: updateCubit),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(),
      ),
    );
  }

  group('HomePage Notification Badge Tests', () {
    testWidgets('notification badge is hidden when no update is available', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Look for the red badge Container decoration
      final redBadgeFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == Colors.red && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(redBadgeFinder, findsNothing);
    });

    testWidgets('notification badge appears when an unskipped update is available', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      repository.latestRelease = const AppRelease(
        version: '3.4.0',
        tagName: 'v3.4.0',
        name: 'Release 3.4.0',
        body: 'New version',
      );
      repository.isAvailable = true;

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final redBadgeFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == Colors.red && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(redBadgeFinder, findsWidgets);
    });
  });
}
