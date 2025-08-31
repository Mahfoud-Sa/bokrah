import 'package:bokrah/app/config/routes.dart';
import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/addBarcoder.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/barcoders_page.dart';
import 'package:bokrah/app/features/invoices/presentation/pages/view_page.dart';
import 'package:bokrah/app/features/home/home_page.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/app_update_screen.dart';
import 'package:bokrah/app/core/services/app_database_service.dart';
import 'package:bokrah/app/initialzation_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:package_info_plus/package_info_plus.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

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
    return MaterialApp.router(
      debugShowMaterialGrid: false,
      title: packageInfo.appName, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRoutes.routers,
     
    );
  }
}
