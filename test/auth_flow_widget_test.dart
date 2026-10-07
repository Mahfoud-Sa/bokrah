import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bokrah/app/config/l10n/app_localizations.dart';
import 'package:bokrah/app/features/auth/data/datasources/auth_token_storage.dart';
import 'package:bokrah/app/features/auth/data/services/mock_auth_service.dart';
import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_cubit.dart';

Widget createTestApp({
  required MockAuthService authService,
  required SharedPreferences prefs,
  Locale locale = const Locale('en'),
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => SettingsCubit(
          localDataSource: SettingsLocalDataSource(sharedPreferences: prefs),
        ),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginPage(authService: authService),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthService authService;
  late SharedPrefsAuthTokenStorage tokenStorage;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    tokenStorage = SharedPrefsAuthTokenStorage(prefs: prefs);
    authService = MockAuthService(
      tokenStorage: tokenStorage,
      simulatedLatency: Duration.zero,
    );
  });

  group('Login Flow Widget Tests', () {
    testWidgets('displays English heading, email field, password field, and Sign In button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(
        authService: authService,
        prefs: prefs,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Welcome! Hungry for something delicious?'), findsOneWidget);
      expect(find.text('Sign in to order your favorite meals.'), findsOneWidget);
      expect(find.text('Email'), findsWidgets);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('displays Arabic heading and RTL layout', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(
        authService: authService,
        prefs: prefs,
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('مرحباً! هل أنت جائع لوجبة شهية؟'), findsOneWidget);
      expect(find.text('سجّل الدخول لتطلب وجباتك المفضلة.'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsWidgets);
      expect(find.text('رقم الهاتف'), findsOneWidget);
    });

    testWidgets('logs in using email and password', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(
        authService: authService,
        prefs: prefs,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      // Enter email and password
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'chef@bokrah.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pump();

      // Tap Sign In button
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(await authService.isAuthenticated(), isTrue);
    });

    testWidgets('switches to phone tab, enters phone and password, and logs in', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(
        authService: authService,
        prefs: prefs,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      // Switch to Phone Number tab
      await tester.tap(find.text('Phone Number'));
      await tester.pumpAndSettle();

      // Dial code should now be visible
      expect(find.text('+966'), findsOneWidget);

      // Enter phone and password
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '501234567');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pump();

      // Tap Sign In button
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(await authService.isAuthenticated(), isTrue);
    });
  });
}
