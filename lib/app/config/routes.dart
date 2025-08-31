
import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/home/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRoutes {
  static final GoRouter routers = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext, state) {
            // if (!showOnBordingPages) {
            //   return HomePage();
            // } else {
              return LoginPage();
           // }
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext, state) {
                PackageInfo packageInfo = state.extra as PackageInfo;
                String appName = packageInfo.appName; 
                return SystemHomePage(packageInfo: packageInfo);
              },
            ),
            // GoRoute(
            //   path: 'Index',
            //   builder: (BuildContext, state) {
            //    // return DedherIndexPage();
            //   },
            // ),
          ])
    ],
  );


}
