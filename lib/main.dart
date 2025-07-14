import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/addBarcoder.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/barcoders_page.dart';
import 'package:bokrah/app/features/invoices/presentation/pages/view_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/home_page.dart';
import 'package:bokrah/app/features/salles/presentation/pages/app_update_screen.dart';
import 'package:bokrah/app/core/services/app_database_service.dart';
import 'package:bokrah/app/initialzation_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await initializationDependencies();
//   String feedURL = 'http://localhost:5002/appcast.xml';
//   await autoUpdater.setFeedURL(feedURL);
//   await autoUpdater.checkForUpdates();
//   await autoUpdater.setScheduledCheckInterval(3600);
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
// String version = packageInfo.version;
// String buildNumber = packageInfo.buildNumber;
//   runApp(const MyApp());
// }

// final GoRouter _router = GoRouter(
//   routes: <RouteBase>[f
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const BarcodersPage();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'addBarcodepage',
//           builder: (BuildContext context, GoRouterState state) {
//             return const AddBarcodePage();
//           },
//         ),
//       ],
//     ),
//   ],
// );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // routerConfig: _router,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const AppUpdateScreen(packageInfo: null,),
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize auto-updater
  // String feedURL = 'http://localhost:5002/appcast.xml';
  // await autoUpdater.setFeedURL(feedURL);
  // await autoUpdater.checkForUpdates();
  // await autoUpdater.setScheduledCheckInterval(3600);

  // Get package info
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print(packageInfo);
  runApp(MyApp(packageInfo: packageInfo));
}

class MyApp extends StatelessWidget {
  final PackageInfo packageInfo;

  const MyApp({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: packageInfo.appName, // Use app name from package info
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),

      //     SystemHomePage(
      //     packageInfo: packageInfo,
      //    ), // AppUpdateScreen(packageInfo: packageInfo),
    );
  }
}
