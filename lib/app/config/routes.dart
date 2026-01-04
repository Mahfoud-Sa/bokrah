import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/home/home_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/items_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter routers = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          // if (!showOnBordingPages) {
          //   return HomePage();
          // } else {
          return const LoginPage();
          // }
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            builder: (context, state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/items',
            builder: (context, state) {
              return const ItemsPage();
            },
          ),
          // GoRoute(
          //   path: 'Index',
          //   builder: (BuildContext, state) {
          //    // return DedherIndexPage();
          //   },
          // ),
        ],
      ),
    ],
  );
}
