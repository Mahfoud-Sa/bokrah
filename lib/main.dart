import 'package:bokrah/app/features/barcoders/presentation/pages/addBarcoder.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/barcoders_page.dart';
import 'package:bokrah/app/features/invoices/presentation/pages/view_page.dart';
import 'package:bokrah/app/features/salles/presentation/pages/home_page.dart';
import 'package:bokrah/app/core/services/app_database_service.dart';
import 'package:bokrah/app/initialzation_dependencies.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializationDependencies();

  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
