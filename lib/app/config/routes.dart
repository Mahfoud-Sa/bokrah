import 'package:bokrah/app/features/auth/login_page.dart';
import 'package:bokrah/app/features/home/home_page.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/barcoders_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/categories_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/items_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/add_item_page.dart';
import 'package:bokrah/app/features/items/data/entities/item_entity.dart';
import 'package:bokrah/app/features/warehouses/presentation/pages/warehouses_page.dart';
import 'package:bokrah/app/features/users/presentation/pages/users_page.dart';
import 'package:bokrah/app/features/users/presentation/pages/profile_page.dart';
import 'package:bokrah/app/features/units/presentation/pages/units_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter routers = GoRouter(
    initialLocation: '/items',
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
          GoRoute(
            path: '/barcodes',
            builder: (context, state) {
              return const BarcodesPage();
            },
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) {
              return const CategoriesPage();
            },
          ),
          GoRoute(
            path: '/warehouses',
            builder: (context, state) {
              return const WarehousesPage();
            },
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) {
              return const UsersPage();
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              return const ProfilePage();
            },
          ),
          GoRoute(
            path: '/units',
            builder: (context, state) {
              return const UnitsPage();
            },
          ),
          GoRoute(
            path: '/add-item',
            builder: (context, state) {
              final item = state.extra as ItemEntity?;
              return AddItemPage(item: item);
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
